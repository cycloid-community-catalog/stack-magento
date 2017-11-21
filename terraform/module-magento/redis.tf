resource "aws_security_group" "redis" {
  name        = "${var.project}-${var.elasticache_engine}-${lookup(var.short_region, var.aws_region)}-${var.env}"
  description = "${var.elasticache_engine} ${var.env} for ${var.project}"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = "${var.elasticache_port}"
    to_port   = "${var.elasticache_port}"
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.front.id}",
    ]
  }

  tags {
    engine  = "cycloid.io"
    Name    = "${var.project}-${var.elasticache_engine}-${lookup(var.short_region, var.aws_region)}-${var.env}"
    env     = "${var.env}"
    project = "${var.project}"
    role    = "redis"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${var.project}-${count.index}-${var.env}"
  engine               = "${var.elasticache_engine}"
  node_type            = "${var.elasticache_type}"
  port                 = "${var.elasticache_port}"
  num_cache_nodes      = "${var.elasticache_nodes}"
  parameter_group_name = "${var.elasticache_parameter_group_name}"
  security_group_ids   = ["${aws_security_group.redis.id}"]
  subnet_group_name    = "${var.cache_subnet}"
  apply_immediately    = true
  maintenance_window   = "tue:06:00-tue:07:00"

  tags {
    engine  = "cycloid.io"
    Name    = "${var.project}-${var.elasticache_engine}-${lookup(var.short_region, var.aws_region)}-${var.env}"
    env     = "${var.env}"
    project = "${var.project}"
  }
}

resource "aws_elasticache_subnet_group" "cache-subnet" {
  name        = "engine-cycloid.io_subnet-cache-${var.vpc_id}"
  count       = "${var.cache_subnet != "" ? 0 : 1}"
  description = "redis cache subnet for ${var.vpc_id}"
  subnet_ids  = ["${var.private_subnets_ids}"]
}
