locals {

  replication_config = {
    enable    = true
    role_name = null // Module will create a role
    rules = [
      {
        delete_marker_replication = "Enabled"

        source_selection_criteria = {
          replica_modifications = {
            status = "Enabled"
          }
          //kms_key_id = optional(string, null)
          sse_kms_encrypted_objects = {
            status = "Disabled"
          }
        }


        destinations = [
          {
            bucket        = "dest-bucket-${random_pet.dest_suffix.id}"
            storage_class = "STANDARD"
            encryption_configuration = {
              replica_kms_key_id = null
            }
        }]
      }
    ]
  }
}
