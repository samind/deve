# mod /etc/ssh/sshd_config

sshd_config = "/etc/ssh/sshd_config"

[ sshd_config ].each do |conf_file|
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
