require 'spec_helper'
describe 'ini_config', :type => :define do
  let(:title) { 'test_config' }

  context 'with defaults for all parameters' do
    it { should contain_ini_config(title) }
  end
end

# vim: sw=2 ts=2 sts=2 et :
