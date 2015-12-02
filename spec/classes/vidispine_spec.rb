require 'spec_helper'

describe 'vidispine' do

  context 'production-like system' do
    let(:facts) {{
      :operatingsystem    => 'Ubuntu',
      :osfamily           => 'Debian',
      :lsbdistcodename    => 'trusty',
      :lsbdistrelease     => '14.04',
      :lsbmajdistrelease  => '14.04',
      :lsbdistdescription => 'Ubuntu 14.04 LTS',
      :lsbdistid          => 'Ubuntu',
      :path               => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin'
    }}

    let(:params) {{ }}
    it { should compile }

    it do
      should contain_class('vidispine::glassfish')
      should contain_class('vidispine::glassfish::install')
      should contain_class('vidispine::glassfish::domain')
      should contain_class('vidispine::glassfish::imq')
      should contain_class('vidispine::install')
      should contain_class('vidispine::config')
    end
  end
end

