require 'spec_helper'

describe 'vidispine' do

  #context 'trivial test' do
    let(:facts) {{
      :operatingsystem    => 'Ubuntu',
      :osfamily           => 'debian',
      :lsbdistcodename    => 'precise',
      :lsbdistrelease     => '12.04',
      :lsbmajdistrelease  => '12.04',
      :lsbdistdescription => 'Ubuntu 12.04 LTS',
      :lsbdistid          => 'Ubuntu',
      :path               => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
    }}

    let(:params) {{ }}
    it { should compile }
  #end
end

