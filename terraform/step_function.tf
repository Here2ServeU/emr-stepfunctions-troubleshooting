resource "aws_iam_role" "step_functions_role" {
  name = "StepFunctionsEMRExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "step_functions_policy" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSStepFunctionsFullAccess"
}

resource "aws_sfn_state_machine" "emr_state_machine" {
  name     = "EMRFeatureEngineeringFlow"
  role_arn = aws_iam_role.step_functions_role.arn
  definition = file("../stepfunctions/state_machine_definition.json")
}
