require 'spec_helper'
describe 'ini_config', :type => :define do
  let (:params) {
    {
      'ensure'            => 'present',
      'config_file'       => '',
      'config'            => {
        'testsection'     => {
          'testvar1'      => 'testvar1',
          'testvar2'      => [ 'testvar2.1', 'testvar2.2' ],
        },
        'testsection.sub' => {
          'testvar3'      => 'testvar3',
        }
      },
      'mode'              => '0440',
      'owner'             => 'foo',
      'group'             => 'bar',
      'quotesubsection'   => true,
      'indentoptions'     => true,
    }
  }

  context 'with good params' do
    let(:title) { '/foo/test.config' }

    it { should contain_ini_config(title) }
    it { should contain_file(title).with(
      :ensure  => 'file',
      :owner   => params['owner'],
      :group   => params['group'],
      :mode    => params['mode'],
      :content => '; MANAGED BY PUPPET

[testsection]
	testvar1 = testvar1
	testvar2 = testvar2.1
	testvar2 = testvar2.2

[testsection "sub"]
	testvar3 = testvar3

',
    ) }

    it "should set a filename of params['config_file'] if passed" do
      params.merge!({'config_file' => '/bar/test.ini'})
      is_expected.to contain_file(params['config_file'])
    end

    it 'should not quote the subsection title if quotesubsection is false' do
      params.merge!({'quotesubsection' => false})
      is_expected.to contain_file(title).with(
        :content => '; MANAGED BY PUPPET

[testsection]
	testvar1 = testvar1
	testvar2 = testvar2.1
	testvar2 = testvar2.2

[testsection sub]
	testvar3 = testvar3

',
      )
    end

    it 'should not indent section options if indentoptions is false' do
      params.merge!({'indentoptions' => false})
      is_expected.to contain_file(title).with(
        :content => '; MANAGED BY PUPPET

[testsection]
testvar1 = testvar1
testvar2 = testvar2.1
testvar2 = testvar2.2

[testsection "sub"]
testvar3 = testvar3

',
      )
    end

    it "should have a config file marked as absent if ensure is 'absent'" do
      params.merge!({'ensure' => 'absent'})
      is_expected.to contain_file(title).with(
        :ensure => 'absent',
      )
    end
  end

  context 'with bad title' do
    let(:title) { 'badtitle' }

    it "should throw an error if title and config_file do not have an absolute path" do
      expect { should compile }.to \
        raise_error(RSpec::Expectations::ExpectationNotMetError,
          /is not an absolute path/)
    end

    it 'should have no problem if config_file has an absolute path' do
      params.merge!({'config_file' => '/bar/conf.ini'})
      is_expected.to contain_file(params['config_file'])
    end
  end
end

# vim: sw=2 ts=2 sts=2 et :
