require 'stove/rake_task'
Stove::RakeTask.new

def prepare_foodcritic_sandbox(sandbox)
  files = %w{*.md *.rb attributes definitions files libraries providers
recipes resources templates}
  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
end

task :default =>[:foodcritic]

task :foodcritic do
 sandbox = File.join(File.dirname(__FILE__), %w{tmp foodcritic cookbook})
 prepare_foodcritic_sandbox(sandbox)
 sh "foodcritic --epic-fail correctness #{File.dirname(sandbox)}"
end