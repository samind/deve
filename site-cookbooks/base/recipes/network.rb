# need to restart manually when modifying network config files

# config files
network_conf = "/etc/sysconfig/network"
eth0_conf = "/etc/sysconfig/network-scripts/ifcfg-eth0"
resolv_conf = "/etc/resolv.conf"
etc_hosts = "/etc/hosts"
 
[ eth0_conf,etc_hosts,resolv_conf,network_conf ].each do |conf_file|
  conf_basename = File.basename(conf_file)
 
  bash "cp_#{conf_basename}_conf_original" do
    code <<-EOC
      cp -p #{conf_file} #{conf_file}.default
    EOC
    creates "#{conf_file}.default"
  end
 
  template conf_file do
    owner "root"
    group "root"
    mode "0644"
  end
end
 
# remove NetworkManager
service 'NetworkManager' do
  action [:disable, :stop]
end


# start network service
service "network " do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end