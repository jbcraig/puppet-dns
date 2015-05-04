require 'spec_helper'

describe 'dns::record' do

  let(:facts) do
    {
      :osfamily   => 'RedHat',
      :fqdn       => 'puppetmaster.example.com',
      :clientcert => 'puppetmaster.example.com',
      :ipaddress  => '192.168.1.1'
    }
  end

  let(:title) { "foo.example.com" }
  let(:params) {{ 
    :target => "vm123.example.com.",
    :type   => "CNAME",
    :comment => "Created by vm123",
  }}


  let :pre_condition do
    'include dns'
    'include stdlib'
  end

  it "should have valid record configuration" do
    verify_concat_fragment_exact_contents(subject, 'dns-static-example.com+foo.example.com.dnsstatic', [
      'foo IN CNAME vm123.example.com.  ; Created by vm123',
    ])
  end

end

at_exit { RSpec::Puppet::Coverage.report! }
