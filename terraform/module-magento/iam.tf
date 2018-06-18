data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Create IAM Role for front
resource "aws_iam_role" "front" {
  name               = "cycloid_${var.env}-front"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
  path               = "/${var.project}/"
}

resource "aws_iam_instance_profile" "front_profile" {
  name = "cycloid_profile-front-${var.project}-${var.env}"
  role = "${aws_iam_role.front.name}"
}

# ec2 tag list policy
data "aws_iam_policy_document" "ec2-tag-describe" {
  statement {
    actions = [
      "ec2:DescribeTags",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2-tag-describe" {
  name        = "${var.env}-${var.project}-ec2-tag-describe"
  path        = "/"
  description = "EC2 tags Read only"
  policy      = "${data.aws_iam_policy_document.ec2-tag-describe.json}"
}

resource "aws_iam_policy_attachment" "ec2-tag-describe" {
  name       = "${var.env}-${var.project}-ec2-tag-describe"
  roles      = ["${aws_iam_role.front.name}"]
  policy_arn = "${aws_iam_policy.ec2-tag-describe.arn}"
}

#####################
# Logs
data "aws_iam_policy_document" "push-logs" {
  statement {
    effect  = "Allow"
    actions = [
      "logs:ListTagsLogGroup",
      "logs:DescribeLogGroups",
      "logs:UntagLogGroup",
      "logs:DescribeLogStreams",
      "logs:DescribeSubscriptionFilters",
      "logs:DescribeMetricFilters",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:TagLogGroup",
      "logs:DeleteRetentionPolicy",
      "logs:PutRetentionPolicy"
    ]
    resources = ["arn:aws:logs:*:*:log-group:${var.project}_${var.env}"]
  }

  statement {
    effect  = "Allow"
    actions = [
      "logs:DescribeExportTasks",
      "logs:TestMetricFilter",
      "logs:CreateLogGroup",
      "logs:DescribeResourcePolicies",
      "logs:DescribeDestinations"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "push-logs" {
  name        = "${var.env}-${var.project}-push-logs"
  path        = "/"
  description = "Push log to cloudwatch"
  policy      = "${data.aws_iam_policy_document.push-logs.json}"
}

resource "aws_iam_policy_attachment" "push-logs" {
  name       = "${var.env}-${var.project}-push-logs"
  roles      = ["${aws_iam_role.front.name}"]
  policy_arn = "${aws_iam_policy.push-logs.arn}"
}
