resource "aws_amplify_app" "tracker_user_amplify" {
  name        = "tracker_user_amplify"
  description = "Amplify app for tracker user. Only use the feature of amplify login (with integration of AWS Cognito) in mobile app."
}

resource "aws_cognito_user_pool" "tracker_user_pool" {
  name = "tracker_user_pool"

}


resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.tracker_user_pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "profile email openid"
    client_id        = "${var.google_app_id}"
    client_secret    = "${var.google_app_secret}"
  }

  attribute_mapping = {
    username = "sub"
  }
}

resource "aws_cognito_identity_provider" "facebook" {
  user_pool_id  = aws_cognito_user_pool.tracker_user_pool.id
  provider_name = "Facebook"
  provider_type = "Facebook"

  provider_details = {
    authorize_scopes = "public_profile,email"
    client_id        = "${var.facebook_app_id}"
    client_secret    = "${var.facebook_app_secret}"
  }

  attribute_mapping = {
    username = "id"
  }
}

resource "aws_cognito_user_pool_client" "tracker_user_pool_client" {
  name            = "tracker_user_pool_client"
  user_pool_id    = aws_cognito_user_pool.tracker_user_pool.id
  generate_secret = false

  supported_identity_providers = ["Google", "Facebook"]
  callback_urls                = ["com.fitnessevo://signIn"]
  logout_urls                  = ["com.fitnessevo://signOut"]

  allowed_oauth_scopes = ["phone", "email", "openid", "aws.cognito.signin.user.admin", "profile"]

  allowed_oauth_flows = ["code"]
}



