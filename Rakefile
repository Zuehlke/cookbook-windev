desc "Publish with knife"
task :publish do
  sh "berks vendor out/cookbooks"
  sh "knife supermarket share windev \"Package Management\" -o ./out/cookbooks"
end
