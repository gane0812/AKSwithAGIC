# Namespace
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
    labels = {
      environment = var.environment
    }
  }
}
/*
resource "kubernetes_namespace" "namespace_chess" {
  metadata {
    name = var.namespace_chess
    labels = {
      environment = var.environment
    }
  }
} */
# Deployment
resource "kubernetes_deployment_v1" "deploy" {
  metadata {
    name      = var.deployment_name
    namespace = var.namespace
    labels = {
      environment = var.environment
    }
  }
  

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app         = var.app_name
          environment = var.environment
        }
      }

      spec {
        container {
          name  = var.app_name
          image = var.container_image

          port {
            container_port = 80
          }
          resources {
            limits   = var.resources.limits
            requests = var.resources.requests
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "deploy_chess" {

  metadata {
    name      = var.deployment_chess_name
    #*****namespace = var.namespace_chess
    namespace = var.namespace
    labels = {
      environment = var.environment
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = var.app_chess_name
      }
    }

    template {
      metadata {
        labels = {
          app         = var.app_chess_name
          environment = var.environment
        }
      }

      spec {
        container {
          name  = var.app_chess_name
          image = var.container_chess_image

            port {
              name           = "http"      
              container_port = 80  
              protocol       = "TCP"
  }
          resources {
            limits   = var.resources.limits
            requests = var.resources.requests
          }
        }
      }
    }
  }
}

# Service
resource "kubernetes_service_v1" "svc" {
  metadata {
    name      = var.service_name
    namespace = var.namespace
    labels = {
      environment = var.environment
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}
resource "kubernetes_service_v1" "svc_chess" {
  metadata {
    name      = var.service_chess_name
    #*****namespace = var.namespace_chess
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.app_chess_name
    }

    port {
      name        = "http"        
      port        = 80
      target_port = "http"       
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}


# Ingress
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.ingress_name
    namespace = var.namespace
    labels = {
      environment = var.environment
    }
   // annotations = var.azure_ingress_annotations
   annotations = {
  "appgw.ingress.kubernetes.io/backend-path-prefix"   = "/"
}
  }

  spec {

    ingress_class_name = "azure-application-gateway"

    rule {
      host = var.ingress_host

      http {
        path {
          path      = "/2048"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.svc.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
        path {
          path      = "/chess"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.svc_chess.metadata[0].name
              port {
                name = "http"
              }
            }
          }
        } 
      }
    }
  }
}
