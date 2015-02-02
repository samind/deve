# mod /etc/selinux/config

selinux_conf = "/etc/selinux/config"

[ selinux_conf ].each do |conf_file|
  conf_basename = File.basename(conf_file)
 
  bash "cp_#{conf_basename}_conf_original" do
    code <<-EOC
      cp -p #{conf_file} #{conf_file}.default
    EOC
    creates "#{conf_file}.default"
  end
end

file '/etc/selinux/config' do
 _file = Chef::Util::FileEdit.new(path)
 _file.search_file_replace("SELINUX=enforcing", "SELINUX=disabled")
 _file.write_file
 content _file.send(:editor).lines.join
end
