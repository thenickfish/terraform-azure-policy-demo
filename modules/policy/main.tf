resource "azurerm_policy_definition" "policy" {
  name         = "VM-Naming-Convention"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "VM_Naming_Convention"

  metadata = <<METADATA
    {
    "category": "Demo"
    }
  METADATA

  policy_rule = <<POLICY_RULE
    {
    "if": {
		"allOf":[
			{
				"not":{
					"field":"name",
					"match":"[parameters('namePattern')]"
				}
			},
			{
				"field": "type",
				"equals": "Microsoft.Compute/virtualMachines"
			}
		]
    },
    "then": { 
      "effect": "deny"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
		"namePattern":{
			"type": "String",
			"metadata":{
				"displayName": "namePattern",
				"description": "? for letter, # for numbers"
			}
		}
  }
PARAMETERS
}

resource "azurerm_policy_assignment" "test-policy-assignment" {
  name                 = "Naming-Convention-Assignment"
  scope                = var.resource_group_id
  policy_definition_id = azurerm_policy_definition.policy.id
  description          = "Naming convention for VM"
  display_name         = "Naming-Convention-Assignment"

  parameters = <<PARAMETERS
{
  "namePattern": {
    "value": "${var.vm_name_pattern}"
  }
}
PARAMETERS
}
