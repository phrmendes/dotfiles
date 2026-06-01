---
name: devops
description: DevOps and infrastructure conventions — Kubernetes, Docker, Terraform, CI/CD.
disable-model-invocation: true
---

## Quick commands

```bash
kubectl get pods -n <ns>         # List pods
kubectl describe deploy <name>   # Inspect deployment
kubectl logs <pod> -n <ns>       # View logs
kubectl apply -f <manifest>      # Apply manifest
docker build -t <name> .         # Build image
docker run <name>                # Run container
terraform plan                   # Preview changes
terraform apply                  # Apply changes
```

## Principles

- Infrastructure changes must be explicit and reversible where possible
- Prefer declarative over imperative (Terraform/Nix/K8s manifests over shell scripts)
- Never hardcode secrets; use environment variables or secret managers
- Validate syntax and dry-run before proposing changes

## Kubernetes

- Always set resource `requests` and `limits` on containers
- Use `readinessProbe` and `livenessProbe` on long-running workloads
- Prefer `Deployment` over bare `Pod`; use `StatefulSet` only when state ordering matters
- Namespace everything; never deploy to `default` in production
- Label resources: `app`, `env`, `version` at minimum

## Docker

- Use multi-stage builds to keep final images minimal
- Prefer slim or distroless base images
- Never run as root; set a non-root `USER`
- Pin base image versions — no `latest` tags in production

## Terraform

- Group logically by service
- Always use remote state; never commit `.tfstate`
- Use variables for environment-specific values
- Run `terraform plan` and review output before `apply`

## CI/CD

- Keep pipeline steps small and independently retryable
- Cache dependencies explicitly
- Fail fast: lint and test before build, build before deploy
- Secrets from CI secret store — never from env files
