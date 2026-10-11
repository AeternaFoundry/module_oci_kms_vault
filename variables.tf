variable "kms_vaults" {
  description = <<EOT
Map of kms_vaults, attributes below
Required:
    - compartment_id
    - display_name
    - vault_type
Optional:
    - defined_tags
    - freeform_tags
    - restore_trigger
    - time_of_deletion
    - external_key_manager_metadata (block):
        - external_vault_endpoint_url (required)
        - oauth_metadata (required, block):
            - client_app_id (required)
            - client_app_secret (required)
            - idcs_account_name_url (required)
        - private_endpoint_id (required)
    - restore_from_file (block):
        - content_length (required)
        - content_md5 (optional)
        - restore_vault_from_file_details (required)
    - restore_from_object_store (block):
        - bucket (optional)
        - destination (required)
        - namespace (optional)
        - object (optional)
        - uri (optional)
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    compartment_id   = string
    display_name     = string
    vault_type       = string
    defined_tags     = optional(map(string))
    freeform_tags    = optional(map(string))
    restore_trigger  = optional(bool)
    time_of_deletion = optional(string)
    external_key_manager_metadata = optional(object({
      external_vault_endpoint_url = string
      oauth_metadata = object({
        client_app_id         = string
        client_app_secret     = string
        idcs_account_name_url = string
      })
      private_endpoint_id = string
    }))
    restore_from_file = optional(object({
      content_length                  = string
      content_md5                     = optional(string)
      restore_vault_from_file_details = string
    }))
    restore_from_object_store = optional(object({
      bucket      = optional(string)
      destination = string
      namespace   = optional(string)
      object      = optional(string)
      uri         = optional(string)
    }))
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.kms_vaults : (
        v.restore_from_object_store == null || (contains([for v in ["BUCKET", "PRE_AUTHENTICATED_REQUEST_URI"] : lower(v)], lower(v.restore_from_object_store.destination)))
      )
    ])
    error_message = "must be one of: \"BUCKET\", \"PRE_AUTHENTICATED_REQUEST_URI\""
  }
  # Note: 1 additional provider-side validator is enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

