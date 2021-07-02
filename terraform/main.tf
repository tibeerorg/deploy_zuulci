module "publickey" {
  source = "./_tfmodules/openstack/public_key"

  project = var.project
}

module "secgroup_zuul_ssh" {
  source = "./_tfmodules/openstack/security_group"

  project   = "${var.project}-ssh"
  from_port = 22
  to_port   = 22
}

module "secgroup_zuul_web" {
  source = "./_tfmodules/openstack/security_group"

  project   = "${var.project}-web"
  from_port = 9000
  to_port   = 9000
}

module "secgroup_zuul_log" {
  source = "./_tfmodules/openstack/security_group"

  project   = "${var.project}-log"
  from_port = 8000
  to_port   = 8000
}

module "zuul" {
  source = "./_tfmodules/openstack/basic_vm"

  project   = "${var.project}-controller"
  pubkey    = module.publickey.public_key
  secgroups = [
    module.secgroup_zuul_ssh.secgroup,
    module.secgroup_zuul_web.secgroup,
    module.secgroup_zuul_log.secgroup
  ]
  flavor    = "2C-2GB-20GB"
  image     = "Ubuntu 20.04"
  fip_pool  = "external"
  network   = "cc0afc40-bbbc-4df3-8cf3-990de6624a0d"
  disk_size = 20
}
