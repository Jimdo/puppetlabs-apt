require 'spec_helper'
describe 'apt::params', :type => :class do
  let (:title) { 'my_package' }

  it { should contain_apt__params }

  # There are 4 resources in this class currently
  # there should not be any more resources because it is a params class
  # The resources are class[apt::params], class[main], class[settings], stage[main]
  it "Should not contain any resources" do
    subject.resources.size.should == 4
  end

  context "with own mirror" do
    let (:params) { {
      :mirror_location => { 'http://ftp.uk.debian.org' => 'http://debmirror.fqdn/ftp.uk.debian.org' }
    } }

    it "Should have reasonable key/values" do
      subject.resource('Class[Apt::Params]')[:mirror_location].should have_key('http://ftp.uk.debian.org')
      subject.resource('Class[Apt::Params]')[:mirror_location]['http://ftp.uk.debian.org'].should eq("http://debmirror.fqdn/ftp.uk.debian.org")
    end
  end

  context "with multiple own mirror" do
    let (:params) { {
      :mirror_location => { 'http://ftp.uk.debian.org' => 'http://debmirror.fqdn/ftp.uk.debian.org',
                            'apt.puppetlabs.com' => 'http://debmirror.fqdn/apt.puppetlabs.com' }
    } }

    it "Should have reasonable key/values" do
      subject.resource('Class[Apt::Params]')[:mirror_location].should have_key('http://ftp.uk.debian.org')
      subject.resource('Class[Apt::Params]')[:mirror_location]['http://ftp.uk.debian.org'].should eq("http://debmirror.fqdn/ftp.uk.debian.org")
      subject.resource('Class[Apt::Params]')[:mirror_location].should have_key('apt.puppetlabs.com')
      subject.resource('Class[Apt::Params]')[:mirror_location]['apt.puppetlabs.com'].should eq("http://debmirror.fqdn/apt.puppetlabs.com")
    end
  end
end
