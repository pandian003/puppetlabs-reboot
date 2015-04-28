test_name "Reboot Module - Linux Provider - Reboot when Refreshed Explicit"
extend Puppet::Acceptance::Reboot

reboot_manifest = <<-MANIFEST
notify { 'step_1':
}
~>
reboot { 'now':
  when => refreshed,
  provider => linux,
}
MANIFEST

confine :except, :platform => 'windows' do |agent|
  fact_on(agent, 'kernel') == 'Linux'
end

linux_agents.each do |agent|
  step "Reboot when Refreshed (Explicit)"

  #Apply the manifest.
  on agent, puppet('apply', '--debug'), :stdin => reboot_manifest

  #Verify that a shutdown has been initiated and clear the pending shutdown.
  retry_shutdown_abort(agent)
end
