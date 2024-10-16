resource "aws_iam_user" "user_data_script" {
  name = "user_data_script"
}

data "aws_iam_policy_document" "user_data_script" {
  statement {
    sid = "ParameterStore"
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/lightsail-wordpress/compose_environment/*",
    ]
  }
}

resource "aws_iam_policy" "user_data_script" {
  name   = "user_data_script"
  policy = data.aws_iam_policy_document.user_data_script.json
}

resource "aws_iam_user_policy_attachment" "user_data_script" {
  user       = aws_iam_user.user_data_script.name
  policy_arn = aws_iam_policy.user_data_script.arn
}
