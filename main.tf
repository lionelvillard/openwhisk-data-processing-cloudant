provider "ibmcloud" {
  bluemix_api_key = "${var.bluemix_api_key}"
  softlayer_username = "${var.slusername}"
  softlayer_api_key = "${var.slapikey}"
}

data "ibmcloud_cf_space" "spacedata" {
  space = "${var.cf_space}"
  org   = "${var.cf_org}"
}

# Provision Cloudant
resource "ibmcloud_cf_service_instance" "cloudant" {
  name       = "${var.database}"
  space_guid = "${data.ibmcloud_cf_space.spacedata.id}"
  service    = "cloudantNoSQLDB"
  plan       = "Lite"
  tags       = ["cluster-service", "cluster-bind"]
}

# Create credentials
resource "ibmcloud_cf_service_key" "cloudant" {
  name                  = "cloudantkey"
  service_instance_guid = "${ibmcloud_cf_service_instance.cloudant.id}"
}

//
//output "credentials" {
//  value = "${ibmcloud_cf_service_key.cloudant.credentials}"
//}
//
//output "guid" {
//  value = "${ibmcloud_cf_service_instance.cloudant.service_plan_guid}"
//}
