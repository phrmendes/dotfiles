---
name: devops
description: Conventions and rules for DevOps and infrastructure work. Load this when working with infra, CI/CD, Kubernetes, Docker, or Terraform.
---

## Principles
- Infrastructure changes must be explicit and reversible where possible
- Prefer declarative over imperative (Terraform/Nix/K8s manifests over shell scripts)
- Never hardcode secrets; use environment variables, secret references, or a secrets manager
- Validate syntax and dry-run before proposing changes to pipelines or infra

## Kubernetes
- Always set resource `requests` and `limits` on containers
- Use `readinessProbe` and `livenessProbe` on long-running workloads
- Prefer `Deployment` over bare `Pod`; use `StatefulSet` only when state ordering matters
- Namespace everything; never deploy to `default` in production
- Label resources consistently: `app`, `env`, `version` at minimum

## Docker
- Use multi-stage builds to keep final images minimal
- Prefer slim or distroless base images
- Never run as root; set a non-root `USER` in the final stage
- Pin base image versions — no `latest` tags in production

## Terraform
- One resource per file is not required, but group logically by service
- Always use remote state; never commit `.tfstate`
- Use variables for anything environment-specific; no hardcoded values
- Run `terraform plan` and review output before `apply`

## CI/CD
- Keep pipeline steps small and independently retryable
- Cache dependencies explicitly (e.g. uv cache, mix deps)
- Fail fast: lint and test before build, build before deploy
- Secrets must come from the CI secret store — never from env files committed to the repo
