resource "oci_kms_vault" "kms_vaults" {
  for_each = var.kms_vaults

  compartment_id   = each.value.compartment_id
  display_name     = each.value.display_name
  vault_type       = each.value.vault_type
  defined_tags     = each.value.defined_tags
  freeform_tags    = each.value.freeform_tags
  restore_trigger  = each.value.restore_trigger
  time_of_deletion = each.value.time_of_deletion

  dynamic "external_key_manager_metadata" {
    for_each = each.value.external_key_manager_metadata != null ? [each.value.external_key_manager_metadata] : []
    content {
      external_vault_endpoint_url = external_key_manager_metadata.value.external_vault_endpoint_url
      oauth_metadata {
        client_app_id         = external_key_manager_metadata.value.oauth_metadata.client_app_id
        client_app_secret     = external_key_manager_metadata.value.oauth_metadata.client_app_secret
        idcs_account_name_url = external_key_manager_metadata.value.oauth_metadata.idcs_account_name_url
      }
      private_endpoint_id = external_key_manager_metadata.value.private_endpoint_id
    }
  }

  dynamic "restore_from_file" {
    for_each = each.value.restore_from_file != null ? [each.value.restore_from_file] : []
    content {
      content_length                  = restore_from_file.value.content_length
      content_md5                     = restore_from_file.value.content_md5
      restore_vault_from_file_details = restore_from_file.value.restore_vault_from_file_details
    }
  }

  dynamic "restore_from_object_store" {
    for_each = each.value.restore_from_object_store != null ? [each.value.restore_from_object_store] : []
    content {
      bucket      = restore_from_object_store.value.bucket
      destination = restore_from_object_store.value.destination
      namespace   = restore_from_object_store.value.namespace
      object      = restore_from_object_store.value.object
      uri         = restore_from_object_store.value.uri
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

