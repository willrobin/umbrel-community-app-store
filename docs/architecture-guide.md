# Multi-Architecture Guide for Umbrel Apps

Umbrel runs on multiple architectures:
- **ARM64** (Raspberry Pi 4/5, Apple Silicon)
- **AMD64** (x86_64 PCs, Intel/AMD servers)

Apps must support both architectures to work for all Umbrel users.

## Quick Reference

| Architecture | Devices | Docker Platform |
|--------------|---------|-----------------|
| ARM64 | Raspberry Pi, Apple M1/M2/M3 | `linux/arm64` |
| AMD64 | Intel/AMD PCs, most VPS | `linux/amd64` |

## Best Practice: Multi-Architecture Images

**Always use Docker images with multi-architecture manifests.** These automatically select the correct architecture when pulled.

### How to Check if an Image is Multi-Arch

```bash
# Check available platforms for an image
docker manifest inspect <image>:<tag> | grep -A2 "platform"

# Example: postgres:15-alpine supports both
docker manifest inspect postgres:15-alpine
```

### Example: Good Multi-Arch Images

These images work on both ARM64 and AMD64:

```yaml
# PostgreSQL - official image supports multi-arch
image: postgres:15-alpine@sha256:6212aa53dcbd...

# Redis - official image supports multi-arch
image: redis:7-alpine@sha256:de13e74e14b98...

# Node.js - official image supports multi-arch
image: node:20-alpine@sha256:...
```

## Problem: Single-Architecture Images

Some applications only publish architecture-specific images:

| Image | Architecture | Notes |
|-------|--------------|-------|
| `calcom/cal.com:v5.x.x` | AMD64 only | Won't work on Raspberry Pi |
| `calcom/cal.com:v5.x.x-arm` | ARM64 only | Won't work on x86 PCs |

### Solutions for Single-Arch Images

#### Option 1: Separate App Variants (Recommended for Production)

Create two app variants:
- `kasa-myapp` (AMD64)
- `kasa-myapp-arm` (ARM64)

Each has its own docker-compose.yml with the correct image.

#### Option 2: Document Architecture Requirements

If only one architecture is common for your users, document the requirement clearly:

```markdown
## System Requirements

**This app requires AMD64 architecture.**
- Works: Intel/AMD PCs, most cloud servers
- Does NOT work: Raspberry Pi, Apple Silicon
```

#### Option 3: Build Your Own Multi-Arch Image

If you maintain the Dockerfile, build multi-arch:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag myregistry/myapp:v1.0.0 \
  --push .
```

## Docker Image Best Practices

### 1. Pin Images with SHA256 Digests

Always pin images to prevent unexpected changes:

```yaml
# Good - pinned to specific digest
image: postgres:15-alpine@sha256:6212aa53dcbd290ccd57f5c02e58c55900e831ba45d4b5c2d2d7f11ee9de4c75

# Bad - can change unexpectedly
image: postgres:15-alpine
image: postgres:latest
```

### 2. Use Multi-Arch Digests

The digest must be the **manifest list digest**, not an architecture-specific digest:

```bash
# Get the multi-arch manifest digest
docker manifest inspect postgres:15-alpine --verbose | jq '.[0].Descriptor.digest'
```

### 3. Verify Before Publishing

Test on both architectures if possible:
- Use `docker buildx` for local multi-arch testing
- Test on actual Raspberry Pi if targeting ARM users

## Checking Your Umbrel's Architecture

Users can check their architecture:

```bash
# On Umbrel via SSH
uname -m
# aarch64 = ARM64
# x86_64 = AMD64
```

## Common Multi-Arch Image Sources

| Registry | Multi-Arch Support |
|----------|-------------------|
| Docker Official Images | Excellent |
| LinuxServer.io | Excellent |
| Bitnami | Good |
| GitHub Container Registry | Varies |
| Random Docker Hub images | Often single-arch |

## Troubleshooting

### "no matching manifest for linux/arm64"

The image doesn't support ARM64. Solutions:
1. Find an alternative image with multi-arch support
2. Use the `-arm` variant if available
3. Build your own multi-arch image

### "exec format error"

You're running an image built for a different architecture:
- ARM64 device trying to run AMD64 image, or vice versa

Check with:
```bash
docker inspect <image> | grep Architecture
```

### App installs but crashes immediately

Often an architecture mismatch. Check container logs:
```bash
docker logs <container_name>
```

## Resources

- [Docker Multi-Platform Builds](https://docs.docker.com/build/building/multi-platform/)
- [Umbrel App Development](https://github.com/getumbrel/umbrel-apps)
- [Docker Official Images](https://hub.docker.com/search?q=&type=image&image_filter=official)
