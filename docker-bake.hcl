group "default" {
  targets = ["backend-server", "room-server", "web-server", "init-db", "openresty", "update-appdata"]
}

variable "IMAGE_REGISTRY" {
  default = "docker.io/matthewlount/apitable-"
}

variable "SEMVER_FULL" {
  default = "v0.0.0-alpha"
}

variable "IMAGE_TAG" {
  default = "latest"
}

target "backend-server" {
  context = "."
  dockerfile = "packaging/Dockerfile.backend-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}backend-matt-mod:latest", "${IMAGE_REGISTRY}backend-matt-mod:${IMAGE_TAG}"]
}

target "room-server" {
  context = "."
  dockerfile = "packaging/Dockerfile.room-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}room-server-matt-mod:latest", "${IMAGE_REGISTRY}room-server-matt-mod:${IMAGE_TAG}"]
}

target "web-server" {
  context = "."
  dockerfile = "packaging/Dockerfile.web-server"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}web-server-matt-mod:latest", "${IMAGE_REGISTRY}web-server-matt-mod:${IMAGE_TAG}"]
}

target "init-db" {
  context = "./init-db"
  dockerfile = "Dockerfile"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}init-db-matt-mod:latest", "${IMAGE_REGISTRY}init-db-matt-mod:${IMAGE_TAG}"]
}

target "update-appdata" {
  context = "./update-appdata"
  dockerfile = "Dockerfile"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}update-appdata-matt-mod:latest", "${IMAGE_REGISTRY}update-appdata-matt-mod:${IMAGE_TAG}"]
}

target "openresty" {
  context = "./gateway"
  dockerfile = "../packaging/Dockerfile.openresty"
  args = {
    SEMVER_FULL = SEMVER_FULL
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}openresty-matt-mod:latest", "${IMAGE_REGISTRY}openresty-matt-mod:${IMAGE_TAG}"]
}

target "all-in-one" {
  context = "./packaging/all-in-one/all-in-one"
  dockerfile = "Dockerfile"
  args = {
    SEMVER_FULL = SEMVER_FULL
    IMAGE_TAG = IMAGE_TAG
  }
  platforms = ["linux/amd64"]
  tags = ["${IMAGE_REGISTRY}all-in-one-matt-mod:latest", "${IMAGE_REGISTRY}all-in-one-matt-mod:${IMAGE_TAG}"]
}
