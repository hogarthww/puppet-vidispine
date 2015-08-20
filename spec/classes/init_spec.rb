require 'spec_helper'
describe 'vidispine' do

  context 'with defaults for all parameters' do
    it { should contain_class('vidispine') }
  end
end
