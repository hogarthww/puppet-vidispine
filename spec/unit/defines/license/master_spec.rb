require 'spec_helper'

describe 'vidispine::license::master', :type => :define do

  let(:title) { 'master' }

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
      java_home                => '/usr/lib/jvm/j2sdk1.7-oracle/jre',
      vidispine_version        => '4.2.99',
      glassfish_das_host       => 'localhost',
      glassfish_http_port      => '8080',
      vidispine_admin_user     => 'admin',
      vidispine_admin_password => 'admin',
    }
    EOT
  end

  describe 'should insist on some content' do
    it { should raise_error(/content of license can't be empty/) }
  end

  describe 'should install and validate with default parameters' do
    let(:params) do
      {
        :content => 'rspec',
      }
    end

    it {
      should contain_vidispine_license_validation('master').with( {
        :timeout => 60,
        :vsurl   => 'http://localhost:8080',
        :vsuser  => 'admin',
        :vspass  => 'admin',
      } )

      should contain_file('/opt/glassfish3/glassfish/domains/vidispine-domain/License.lic') \
        .with_content(/rspec/)
    }
  end

  describe 'should skip validation if asked' do
    let(:params) do
      {
        :content => 'rspec',
        :validate => false,
      }
    end

    it {
      should_not contain_vidispine_license_validation('master')

      should contain_file('/opt/glassfish3/glassfish/domains/vidispine-domain/License.lic') \
        .with_content(/rspec/)
    }
  end

end

