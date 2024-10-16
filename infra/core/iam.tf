resource "aws_iam_access_key" "user_data_script" {
  user    = data.aws_iam_user.user_data_script.user_name
  status  = "Active"
}
