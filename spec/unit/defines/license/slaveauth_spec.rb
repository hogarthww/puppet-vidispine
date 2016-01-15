require 'spec_helper'

describe 'vidispine::license::slaveauth', :type => :define do

  let(:title) { 'slave' }

  let(:facts) do
    {
      :osfamily        => 'Debian',
      :operatingsystem => 'Ubuntu',
      :lsbdistcodename => 'trusty',
    }
  end

  let(:pre_condition) do
    <<-EOT
    class { '::vidispine':
      java_home                  => '/usr/lib/jvm/j2sdk1.7-oracle/jre',
      vidispine_version          => '4.2.99',
      vidispine_archive_location => '/tmp',
      glassfish_das_host         => 'localhost',
      glassfish_http_port        => '8080',
      vidispine_admin_user       => 'admin',
      vidispine_admin_password   => 'admin',
    }
    EOT
  end

  describe 'should insist on master node addresses' do
    it { should raise_error(/master_node_address/) }
  end

  describe 'with single master and default parameters' do
    let(:params) do
      {
        :master_node_address => [ '192.0.2.99' ]
      }
    end

    it {
      should contain_vidispine_license_validation('slave').with( {
        :timeout => 60,
        :vsurl   => 'http://localhost:8080',
        :vsuser  => 'admin',
        :vspass  => 'admin',
      } )

      should contain_file('/opt/glassfish3/glassfish/domains/vidispine-domain/slaveAuth.lic') \
        .with_content(//)
    }
  end
end

