---
name: nginx-stable-migration
description: Guides migration when Marriott's NGINX base image changes from old /usr/local/nginx layout to new /usr/share/nginx layout. Handles Dockerfile updates (including HEALTHCHECK with PORT from EXPOSE/helm), path changes, amd64 platform requirements on arm64 Macs, and secret handling for Artifactory. Use for any RM Portal or similar React + Nginx Marriott project.
license: Internal Marriott use only
---

# NGINX Stable Migration

Handles migration when switching to the new `artifactory.marriott.com/icd/icd-baseimages-nginx:stable` image which uses different filesystem paths than previous versions.

## When to Use This Skill

When specifically asked to "update marriott nginx"

**Projects this applies to**: Any Marriott React app using the ICD nginx base image (rm-portal, learning-rm-portal, dlz-frontend, etc.). Supports both rtconfig.js + index.html injection patterns and index.html-only variants.

**Key learnings from dlz migration**: Always inspect public/index.html and public/rtconfig.js for placeholder patterns. Make rtconfig chown conditional. Provide robust entrypoint.sh examples that avoid temp file bugs and support variable sets of env vars. Dockerfile pathing must precisely match WORKDIR + COPY destinations. Add HEALTHCHECK using curl to /health with PORT from EXPOSE or helm charts.

## Migration Checklist

### 1. Update Dockerfiles

**Update both `Dockerfile` and `Dockerfile.local`:**

```dockerfile
# Stage 2 - NGINX
FROM artifactory.marriott.com/icd/icd-baseimages-nginx:stable

WORKDIR /usr/share/nginx/

# Cleanup
RUN echo "deleting default files" && \
  rm -Rf /usr/share/nginx/html && \
  rm -Rf /usr/share/nginx/modules

# Copy configs and app
COPY nginx/conf/* /etc/nginx/
COPY nginx/entrypoint.sh /usr/share/nginx/
COPY nginx/html/* html/
COPY --from=builder /src/build/ html/app/

# Permissions
RUN chown root:root /etc/nginx/* && \
  chmod -R a+r /etc/nginx/ && \
  chown marriott:marriott html/app/index.html && \
  chown marriott:marriott html/app/rtconfig.js 2>/dev/null || true

# Healthcheck - PORT from EXPOSE or helm chart (env/prod values.yaml typically 8080)
HEALTHCHECK CMD curl -f http://localhost:${PORT:-8080}/health || exit 1
```

**Notes on rtconfig.js:** Some projects (like dlz) use rtconfig.js loaded from index.html + direct placeholder replacement in index.html itself. Others rely solely on one or the other. The `|| true` makes chown safe if file is absent. Always verify which files contain placeholders (%APPLICATION_NAME%, %BASE_URL%, etc.) by inspecting public/index.html and public/rtconfig.js before migration.

**Key path changes:**

- `/usr/local/nginx` → `/usr/share/nginx/`
- Configs go to `/etc/nginx/` instead of `/usr/local/nginx/conf`
- HTML goes to `html/` (relative to WORKDIR)

**Healthcheck Configuration:**

Add the HEALTHCHECK to **both** `Dockerfile` and `Dockerfile.local` (as shown above).

The default port should be pulled from:
- `EXPOSE <port>` directive in the original Dockerfile (preferred)
- Fallback: check `env/prod/` helm chart values (e.g. `values.yaml`, `configmap.yaml` or deployment yaml) for `containerPort`, `targetPort` or service port (commonly 8080)

Ensure nginx/conf/nginx.conf has a `/health` location block (e.g. serving a static health.html or proxying to app).

### 2. Update package.json Build Scripts

```json
"build:docker:dev": "docker build --secret id=ARTIFACTORY_TOKEN,env=ARTIFACTORY_TOKEN -f Dockerfile.dev -t dlz:dev --platform linux/amd64 .",
"build:docker:local": "docker build --secret id=ARTIFACTORY_TOKEN,env=ARTIFACTORY_TOKEN -f Dockerfile.local -t dlz --platform linux/amd64 .",
"start:docker:local": "docker run --rm -it -p 8081:8080 --platform linux/amd64 dlz"
```

**Why:**

- New nginx image is amd64-only; `--secret` + `--platform linux/amd64` for M1+ Macs and private Artifactory
- Add `--mount=type=secret,id=ARTIFACTORY_TOKEN,env=ARTIFACTORY_TOKEN` to RUN npm/ci commands in _both_ Dockerfile and Dockerfile.local builder stages (e.g. for .npmrc setup)
- New start:docker:local for easy local testing of built image on port 8081

### 3. Update nginx/ Configuration

**nginx/conf/nginx.conf:**

- Update `root` directive to `/usr/share/nginx/html` (critical for location blocks serving static assets and SPA routing)
- Update any alias paths (e.g. /health to point to html/health.html)
- Update pid/temp paths if needed (`/tmp/nginx.pid`, client_body_temp_path etc. - these often stay the same but verify)
- **Location routing:** `location ^~ / { root /usr/share/nginx/html/app; try_files $uri $uri/ /index.html; }` is validated as correct for SPA ( ^~ gives priority over regex locations, ensuring all routes fall to index.html without conflicting with /health)
- Ensure try_files works with the new html/app/ structure for React apps

**nginx/entrypoint.sh (detailed guidance - 2x verbosity):**

- Update any hardcoded paths to match new structure (/usr/local/nginx → /usr/share/nginx/ or use relative from WORKDIR)
- Most projects inject runtime config via sed replacing placeholders like %APPLICATION_NAME%, %BASE_URL%, %API_URL%, %CMDB_API_URL%, %LOGOUT_ENABLED%, %GA_ID%
- Common pattern (from dlz): escape vars safely with printf+sed, use mktemp for safe in-place edit, update BOTH rtconfig.js (for window._env_) AND index.html (for <title>, script src, links). **Bug fixed:** ensure second sed cats $IDX_TEMP_FILE (not $TEMP_FILE) and cleans up temps with `rm -f`.
- Cross-check: verify no undefined vars or quoting issues that could cause hangs during sed expansion.
- Example improved entrypoint.sh (adapt to your env vars):

```bash
#!/usr/bin/bash
echo "Injecting environment variables into HTML..."
# Define escaped vars (add/remove as needed for your app)
APPLICATION_NAME_ESCAPED=$(printf '%s\n' "${APPLICATION_NAME:-DLZ}" | sed -e 's/[\/&]/\\&/g')
BASE_URL_ESCAPED=$(printf '%s\n' "$BASE_URL" | sed -e 's/[\/&]/\\&/g')
# ... (other vars)
RT_TEMP_FILE=$(mktemp)
IDX_TEMP_FILE=$(mktemp)
# Update rtconfig.js if present
if [ -f html/app/rtconfig.js ]; then
  sed -e "s/%APPLICATION_NAME%/$APPLICATION_NAME_ESCAPED/" ... html/app/rtconfig.js > $RT_TEMP_FILE && cat $RT_TEMP_FILE > html/app/rtconfig.js
fi
# Update index.html
sed ... html/app/index.html > $IDX_TEMP_FILE && cat $IDX_TEMP_FILE > html/app/index.html
nginx -g 'daemon off;'
```

- Test by inspecting the files after container start to confirm substitutions succeeded. This pattern supports both rtconfig and index.html-only projects.

**Recommended mktemp patterns for sed (avoids collisions with fixed names like /tmp/rtconfig.js.tmp):**

Use `mktemp` to create unique temporary files for safe sed output redirection. `RT_` prefix = runtime config, `IDX_` = index.html.

**Example 1 (peg-style, rtconfig.js only):**
```
RT_TEMP_FILE=$(mktemp)

sed \
  -e "s/%BASE_URL%/$BASE_URL_ESCAPED/" \
  -e "s/%API_URL%/$API_URL_ESCAPED/" \
  -e "s/%CMDB_API_URL%/$CMDB_API_URL_ESCAPED/" \
  -e "s/%PUBLIC_URL%/$PUBLIC_URL_ESCAPED/" \
  /usr/share/nginx/html/peg/rtconfig.js > $RT_TEMP_FILE && \
  cat $RT_TEMP_FILE > /usr/share/nginx/html/peg/rtconfig.js 
```

**Example 2 (full, rtconfig.js + index.html with cleanup):**
```
# Temp files used for sed operations
RT_TEMP_FILE=$(mktemp)
IDX_TEMP_FILE=$(mktemp)

# Update runtime config file
sed \
  -e "s/%APPLICATION_NAME%/$APPLICATION_NAME_ESCAPED/" \
  -e "s/%BASE_URL%/$BASE_URL_ESCAPED/" \
  -e "s/%API_URL%/$API_URL_ESCAPED/" \
  -e "s/%CMDB_API_URL%/$CMDB_API_URL_ESCAPED/" \
  -e "s/%LOGOUT_ENABLED%/$LOGOUT_ENABLED_ESCAPED/" \
  -e "s/%GA_ID%/$GA_ID_ESCAPED/" \
  /usr/share/nginx/html/app/rtconfig.js > $RT_TEMP_FILE && \
  cat $RT_TEMP_FILE > /usr/share/nginx/html/app/rtconfig.js

# Update static public index file
sed \
  -e "s/%BASE_URL%/$BASE_URL_ESCAPED/g" \
  -e "s/%APPLICATION_NAME%/$APPLICATION_NAME_ESCAPED/g" \
  /usr/share/nginx/html/app/index.html > $IDX_TEMP_FILE && \
  cat $IDX_TEMP_FILE > /usr/share/nginx/html/app/index.html && \
  rm -f $RT_TEMP_FILE $IDX_TEMP_FILE 
```

### 4. Update docker-compose.yaml (if used)

Add build configuration:

```yaml
build:
  dockerfile: Dockerfile.dev
  args:
    - ARTIFACTORY_TOKEN
```

### 5. Testing Steps (project-specific)

1. `export ARTIFACTORY_TOKEN=your-token` (required for Artifactory pulls and npm)
2. `npm run build:docker:dev -- --no-cache` and `npm run build:docker:local -- --no-cache` (use your project's script names; dlz uses "dlz:dev" and "dlz")
3. Inspect built image: `docker run --rm <your-image> ls -la /usr/share/nginx/html/app/` and `cat html/app/index.html | grep -E 'env|APPLICATION_NAME'`
4. Test with `docker compose up --build` (for dev) or direct run of local image on port 8080
5. Verify app serves correctly, env vars are injected (check browser console/network for window._env_ or title), no 404s on assets, healthcheck passes
6. For dlz-like: confirm both rtconfig.js and index.html have correct substitutions without JS errors

### Common Gotchas (expanded based on dlz migration)

- **Cache**: Always use `--no-cache` on first migration because layer caching can retain old rm commands and path references from previous builds
- **Permissions**: The new image is stricter about user permissions - always run chown for marriott user on html/app/index.html (and rtconfig.js if present); use `2>/dev/null || true` for optional files
- **Healthcheck**: Ensure `HEALTHCHECK CMD curl -f http://localhost:${PORT:-8080}/health || exit 1` is added to both Dockerfiles. Match PORT to EXPOSE or helm values. Verify `/health` endpoint in nginx.conf.
- **Volume mounts**: Ensure dev mode still works with volume mounts (dlz uses docker-compose for node dev on port 3311, separate from nginx prod)
- **rtconfig vs index.html**: Inspect public/ for placeholders before assuming structure; some projects write all config to index.html while loading rtconfig.js - test both files post-injection
- **Sed/Env bugs**: Watch for temp file var mixups in entrypoint.sh; ensure all env vars used in HTML/JS are passed to container and escaped properly
- **Multiple projects**: Create a checklist per project as paths may vary slightly; dlz used dlz:dev tag and had extra local perms in Dockerfile.local
- **Builder stage**: Confirm builder outputs to /src/build/ and respects REACT*APP*\* env vars

**Migration Template (updated):**

1. Update Dockerfiles (paths + base image + HEALTHCHECK with PORT logic + optional rtconfig + platform/secret)
2. Update package.json scripts (platform + secret; test both dev and local)
3. Update nginx/conf/nginx.conf and entrypoint.sh (paths, sed logic for your specific env vars)
4. Test build + run (with ARTIFACTORY_TOKEN; inspect injected files)
5. Update any deployment yamls if image names changed; add .claude/notes/ for project-specific variations

## Migration Template

For each project:

1. Update Dockerfiles (paths + base image + HEALTHCHECK CMD curl ... with PORT from EXPOSE/helm)
2. Update package.json scripts (platform + secret)
3. Update nginx/conf/nginx.conf
4. Test build + run
5. Update any deployment yamls if image names changed

**See `references/` for project-specific variations.**
