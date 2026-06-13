output "ecs_cluster_name" {
  value       = aws_ecs_cluster.tc1_cluster.name
  description = "ECS Cluster name"
}

output "backend_service_name" {
  value       = aws_ecs_service.backend.name
  description = "Backend service name"
}

output "frontend_service_name" {
  value       = aws_ecs_service.frontend.name
  description = "Frontend service name"
}

output "load_balancer_dns" {
  value       = aws_lb.tc1_alb.dns_name
  description = "Load Balancer DNS name"
}
