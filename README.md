opsworks-kibana
===============

This is a wrapper cookbook which utilizes the [kibana library cookbook](https://github.com/lusis/chef-kibana) for installing [Kibana 3](http://www.elasticsearch.org/overview/kibana/)
on AWS OpsWorks instances.

Requirements
============

* **kibana** (≥ 1.3.0)
* **git** (~ 3.1.0)
* **nodejs** (~ 2.2.0)

Recipes
=======

This cookbook contains recipes that will help install and configure **Kibana 3**
on your **AWS OpsWorks** server.

install
-------

Installs **Kibana** to the directory specified under `node[:kibana][:install_path]`
(`/var/www` by default) and sets up **nginx** reverse proxy.

This recipe should run during the **Setup** stage in your **Layer**.

**Example:**

![OpsWorks Layer Setup](https://s3-us-west-1.amazonaws.com/opsworks-elk/opsworks_kibana--install.png)

config
------

Creates config.js required by **Kibana**.

It is recommended that this recipe run during the **Configure** stage in your
**Layer**.

**Example:**

![OpsWorks Layer Configure](https://s3-us-west-1.amazonaws.com/opsworks-elk/opsworks_kibana--configure.png)

License
=======

This cookbook is license and distributed under the Simplified BSD license. See
[LICENSE](https://github.com/verdigris-cookbooks/opsworks-kibana/blob/master/LICENSE)
for more details.
