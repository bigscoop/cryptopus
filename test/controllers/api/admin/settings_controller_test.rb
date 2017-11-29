# encoding: utf-8

# Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
# Cryptopus and licensed under the Affero General Public License version 3 or later.
# See the COPYING file at the top-level directory or at
# https://github.com/puzzle/cryptopus.

require 'test_helper'

class Api::Admin::SettingsControllerTest < ActionController::TestCase

  include ControllerTest::DefaultHelper

  test 'connection to ldap server success' do
    login_as(:admin)

    Api::Admin::SettingsController.any_instance.expects(:ldap_connection).returns(true)

    patch :test_ldap_connection, params: { settings: { 'host-list': ['ldap1.crypto.pus'], portnumber: '666', encryption: 'example_encryption'} }

    info = JSON.parse(response.body)['messages']['info']

    assert_includes(info, 'Connection to Ldap Server ldap1.crypto.pus successful')
  end

  test 'connection to ldap server fails' do
    login_as(:admin)

    patch :test_ldap_connection, params: { settings: {'host-list': ['ldap1.crypto.pus'], portnumber: '666', encryption: 'example_encryption'} }

    errors = JSON.parse(response.body)['messages']['errors']

    assert_includes(errors, 'Connection to Ldap Server ldap1.crypto.pus failed')
  end

  test 'no hostname is present' do
    login_as(:admin)

    patch :test_ldap_connection, params: { settings: {'host-list': [], portnumber: '666', encryption: 'example_encryption'} }

    errors = JSON.parse(response.body)['messages']['errors']

    assert_includes(errors, 'No hostname present')
  end
end
