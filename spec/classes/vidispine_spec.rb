require 'spec_helper'

describe 'vidispine' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "vidispine version 4.2.99" do
          let(:params) {{
            :java_home                  => '/usr/lib/jvm/j2sdk1.7-oracle/jre',
            :vidispine_version          => '4.2.99',
            :vidispine_archive_location => '/tmp',
          }}
          it { should compile.with_all_deps }

          it do
            should contain_class('vidispine::glassfish')
            should contain_class('vidispine::glassfish::install')
            should contain_class('vidispine::glassfish::domain')
            should contain_class('vidispine::glassfish::imq')
            should contain_class('vidispine::install')
            should contain_class('vidispine::install::legacy')
            should contain_class('vidispine::glassfish::postinstallconfig')
          end
        end

        # Assumption: the same tests are valid for 4.3, 4.4 and 4.5
        context "vidispine version 4.5.99" do
          let(:params) {{
            :java_home         => '/usr/lib/jvm/java-7-openjdk-amd64',
            :vidispine_version => '4.5.99',
            :manage_repo       => true,
          }}

          it { should compile.with_all_deps }

          it do
            should_not contain_class('vidispine::glassfish')
            should_not contain_class('vidispine::install::legacy')
            should     contain_class('vidispine::install')
            should     contain_class('vidispine::repository')
          end
        end
      end
    end
  end
end

