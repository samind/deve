# mod /boot/grub/grub.conf

grub_conf = "/boot/grub/grub.conf"

[ grub_conf ].each do |conf_file|
  conf_basename = File.basename(conf_file)
 
  bash "cp_#{conf_basename}_conf_original" do
    code <<-EOC
      cp -p #{conf_file} #{conf_file}.default
    EOC
    creates "#{conf_file}.default"
  end
end

file '/boot/grub/grub.conf' do
 _file = Chef::Util::FileEdit.new(path)
 _file.search_file_replace("timeout=5", "timeout=0")
 _file.write_file
 content _file.send(:editor).lines.join
end

