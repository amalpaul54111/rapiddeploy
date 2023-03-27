variable "FRAPPE_VERSION" {
  default = "v14.7.0"
}

variable "ERPNEXT_VERSION" {
  default = "v14.1.1"
}

variable "REGISTRY_NAME" {
  default = "tacten_images"
}

variable "ERPNEXT_WORKER_IMAGE_NAME" {
  default = "erpnext_worker"
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

target "erpnext-worker" {
    args = {
        FRAPPE_VERSION = "${FRAPPE_VERSION}"
        ERPNEXT_VERSION = "${ERPNEXT_VERSION}"
        PYTHON_VERSION = can(regex("v13", "${ERPNEXT_VERSION}")) ? "3.9.9" : "3.10.5"
        NODE_VERSION = can(regex("v13", "${FRAPPE_VERSION}")) ? "14.19.3" : "16.18.0"
    }
    context = "images/worker"
    target = "erpnext"
    tags =  ["${REGISTRY_NAME}/${ERPNEXT_WORKER_IMAGE_NAME}:${ERPNEXT_VERSION}"]
}

target "assets" {
  dockerfile = "images/assests.Dockerfile"
  args = {
    "ERPNEXT_VERSION" = ERPNEXT_VERSION
    "FRAPPE_VERSION" = FRAPPE_VERSION
  }
}

target "backend" {
    contexts = {
      assets = "target:assets"
      erpnext-worker = "target:erpnext-worker"
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
