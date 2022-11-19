variable "FRAPPE_VERSION" {
  default = "v14.7.0"
}

variable "ERPNEXT_VERSION" {
  default = "v14.1.1"
}

variable "REGISTRY_NAME" {
  default = "tacten_images"
}

variable "BACKEND_IMAGE_NAME" {
  default = "tacten_worker"
}

variable "FRONTEND_IMAGE_NAME" {
  default = "tacten_nginx"
}

variable "SOCKETIO_IMAGE_NAME" {
  default = "tacten_socketio"
}

variable "VERSION" {
  default = "v1.0"
}

group "default" {
    targets = ["backend", "frontend", "socketio"]
}

target "assets" {
  dockerfile = "images/assests.Dockerfile"
}

target "backend" {
    contexts = {
      assets = "target:assets"
    }
    dockerfile = "images/backend.Dockerfile"
    tags = ["${REGISTRY_NAME}/${BACKEND_IMAGE_NAME}:${VERSION}"]
    args = {
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
    }
}

target "socketio" {
    dockerfile = "images/socketio.Dockerfile"
    tags = ["${REGISTRY_NAME}/${SOCKETIO_IMAGE_NAME}:${VERSION}"]
    args = {
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
      "FRAPPE_VERSION" = FRAPPE_VERSION
    }
}

target "frontend" {
    contexts = {
      assets = "target:assets"
    }
    dockerfile = "images/frontend.Dockerfile"
    tags = ["${REGISTRY_NAME}/${FRONTEND_IMAGE_NAME}:${VERSION}"]
    args = {
      "FRAPPE_VERSION" = FRAPPE_VERSION
      "ERPNEXT_VERSION" = ERPNEXT_VERSION
    }
}
