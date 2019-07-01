#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# --- BEGIN_HEADER ---
#
# accountreq - helpers for certificate/OpenID account requests
# Copyright (C) 2003-2018  The MiG Project lead by Brian Vinter
#
# This file is part of MiG.
#
# MiG is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# MiG is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# -- END_HEADER ---
#

"""This module contains various helper contents for the certificate and OpenID
account request handlers"""

import re
import os
import time

# NOTE: the external iso3166 module is optional and only used if available
try:
    import iso3166
except ImportError:
    iso3166 = None

from shared.fileio import delete_file
from shared.html import themed_styles
# Expose some helper variables for functionality backends
from shared.safeinput import name_extras, password_extras, password_min_len, \
    password_max_len, valid_password_chars, valid_name_chars, dn_max_len
from shared.serial import load, dump


def account_js_helpers(fields):
    """Javascript to include in the cert/oid account req page header"""
    # TODO: change remaining names and messages to fit generic auth account?
    js = '''
<script type="text/javascript" src="/images/js/jquery.js"></script>
<script type="text/javascript" src="/images/js/jquery-ui.js"></script>
<script type="text/javascript" src="/images/js/jquery.form.js"></script>
'''
    js += """
  <script type='text/javascript'>
  function rtfm_warn(message) {
      return confirm(message + ': Proceed anyway? (If you read and followed the instructions!)');
  }
  
  function check_account_id() {
      //alert('#account_id_help');
      if ($('#cert_id_field').val().indexOf('/') == -1) {
          return rtfm_warn('Account ID does not look like a proper x509 DN');
      }
      return true;
  }
  function check_account_name() {
      //alert('#account_name_help');
      if ($('#cert_name_field').val().indexOf(' ') == -1) {
          return rtfm_warn('Full name does not look like a real name');
      }
      return true;
  }
  function check_full_name() {
      //alert('#full_name_help');
      if ($('#full_name_field').val().indexOf(' ') == -1) {
          return rtfm_warn('Full name does not look like a real name');
      }
      return true;
  }
  function check_email() {
      //alert('#email_help');
      if ($('#email_field').val().search('@') == -1) {
          return rtfm_warn('Email is invalid');
      }
      if ($('#email_field').val().search('@gmail.com') != -1 || $('#email_field').val().search('@yahoo.com') != -1 || $('#email_field').val().search('@hotmail.com') != -1) {
          return rtfm_warn('Email does not look like a organization address');
      }
      return true;
  }
  function check_organization() {
      //alert('#organization_help');
      if ($('#email_field').val().search('.ku.dk') != -1 || $('#email_field').val().search('diku.dk') != -1 || $('#email_field').val().search('nbi.dk') != -1) {
          if ($('#organization_field').val().indexOf(' ') != -1) {
              return rtfm_warn('Organization does not look like an acronym');
          }
      }
      return true;
  }
  function check_country() {
      //alert('#country_help');
      return true;
  }
  function check_state() {
      //alert('#state_help');
      if ($('#country_field').val().search('US') == -1) {
          if ($('#state_field').val() && $('#state_field').val() != 'NA') {
              return rtfm_warn('State only makes sense for US users');
          }
      }
      return true;
  }
  function check_password() {
      //alert('#password_help');
      if ($('#password_field').val().length < %(password_min_len)d) {
         return rtfm_warn('Password too short');
      } else if ($('#password_field').val().length > %(password_max_len)d) {
         return rtfm_warn('Password too long');
      }
      return true;
  }
  function check_verifypassword() {
      //alert('#verifypassword_help');
      if ($('#verifypassword_field').val().length < %(password_min_len)d) {
         return rtfm_warn('Verify password too short');
      } else if ($('#verifypassword_field').val().length > %(password_max_len)d) {
         return rtfm_warn('Verify password too long');
      } else if ($('#password_field').val() != $('#verifypassword_field').val()) {
         return rtfm_warn('Mismatch between password and verify password');
      }
      return true;
  }
  function check_comment() {
      //alert('#comment_help');
      return true;
  }

  function init_context_help() {
      /* move help text just right of connecting gfx bubble */
      var contextualHelpMessage = $('#contextual_help').find('.help_message');
      contextualHelpMessage.offset({top: -30})
      contextualHelpMessage.offset({left: 40})
  }
  function close_context_help() {
      //alert('close called');
      $('#contextual_help').hide();
      $('#contextual_help').css({top: '', left: ''}); // fix for 'drifting' on IE/Chrome
  }
  function bind_help(input_element, message) {
      input_element.focus(function () {
          close_context_help();
          var contextualHelp = $('#contextual_help');
          var contextualHelpMessage = $('#contextual_help').find('.help_message');
          contextualHelpMessage.html(message);
          var inputOffset = $(this).offset(); // top, left
          var scrollTop = $(window).scrollTop(); // how much should we offset if the user has scrolled down the page?
          contextualHelp.offset({
              //top: (inputOffset.top + scrollTop + .5 * $(this).height()) - .5 * contextualHelp.height(),
              top: inputOffset.top + scrollTop,
              //left: (inputOffset.left + .5 * $(this).width()) - .5 * contextualHelp.width()
              left: inputOffset.left + $(this).width() + 20
              //left: inputOffset.left + 20
          });
          contextualHelp.show();
      });
  }
""" % {'password_min_len': password_min_len, 'password_max_len': password_max_len}
    js += """
  function validate_form() {
      //alert('validate form');
"""
    js += """
      var status = %s""" % ' && '.join(['check_%s()' % name for name in fields])
    js += """
      //alert('validate form: ' +status);
      return status;
  }

"""
    js += """
  $(document).ready( function() {
      init_context_help();
"""
    for name in fields:
        js += """
      bind_help($('#%s_field'), $('#%s_help').html());
""" % (name, name)
    js += """
  });
</script>
"""
    return js

def build_accountreqitem_object(configuration, accountreq_dict):
    """Build a accountreq object based on input accountreq_dict"""

    created_epoch = accountreq_dict['created']
    created_asctime = time.ctime(created_epoch)
    accountreq_obj = {
        'object_type': 'accountreq',
        'auth': accountreq_dict.get('auth', ['unknown']),
        'id': accountreq_dict['id'],
        'full_name': accountreq_dict['full_name'],
        'email': accountreq_dict['email'],
        'organization': accountreq_dict['organization'],
        'country': accountreq_dict['country'],
        'state': accountreq_dict['state'],
        'comment': accountreq_dict['comment'],
        'created': "<div class='sortkey'>%d</div>%s" % (created_epoch,
                                                        created_asctime),
    }
    return accountreq_obj


def list_account_reqs(configuration):
    """Find all pending certificate/OpenID accounts requests"""
    logger = configuration.logger
    accountreq_list = []
    dir_content = []

    try:
        dir_content = os.listdir(configuration.user_pending)
    except Exception:
        if not os.path.isdir(configuration.user_pending):
            try:
                os.mkdir(configuration.user_pending)
            except Exception, err:
                logger.error(
                    'accountreq.py: not able to create directory %s: %s' %
                    (configuration.accountreq_home, err))
                return (False, "account request setup is broken")
            dir_content = []

    for entry in dir_content:

        # Skip dot files/dirs

        if entry.startswith('.'):
            continue
        if is_account_req(entry, configuration):
            accountreq_list.append(entry)
        else:
            logger.warning(
                '%s in %s is not a file, move it?'
                % (entry, configuration.user_pending))
    return (True, accountreq_list)

def is_account_req(req_id, configuration):
    """Check that req_id is an existing account request"""
    req_path = os.path.join(configuration.user_pending, req_id)
    if os.path.isfile(req_path):
        return True
    else:
        return False

def get_account_req(req_id, configuration):
    """Helper to fetch dictionary for a pending account request"""
    req_path = os.path.join(configuration.user_pending, req_id)
    req_dict = load(req_path)
    if not req_dict:
        return (False, 'Could not open account request %s' % req_id)
    else:
        req_dict['id'] = req_id
        req_dict['created'] = os.path.getctime(req_path)
        return (True, req_dict)

def accept_account_req(req_id, configuration):
    """Helper to accept a pending account request"""
    _logger = configuration.logger
    req_path = os.path.join(configuration.user_pending, req_id)
    # TODO: run createuser
    _logger.warning('account creation from admin page not implemented yet')
    return False

def delete_account_req(req_id, configuration):
    """Helper to delete a pending account request"""
    req_path = os.path.join(configuration.user_pending, req_id)
    return delete_file(req_path, configuration.logger)


def existing_country_code(country_code, configuration):
    """Check that country_code matches an existing code in line with ISO3166"""

    logger = configuration.logger
    if iso3166 is None:
        logger.info("iso3166 module not available - accept all countries")
        return True
    try:
        country = iso3166.countries.get(country_code)
        logger.debug("found country %s for code %s" % (country, country_code))
        # Country object has 2-letter code in alpha2 attribute
        return (country and country.alpha2 == country_code)
    except KeyError:
        logger.warning("no country found for code %s" % country_code)
        return False


def forced_org_email_match(org, email, configuration):
    """Check that email and organization follow the required policy"""

    logger = configuration.logger
    # Policy regexps: prioritized order with most general last
    force_org_email = [('DIKU', ['^[a-zA-Z0-9_.+-]+@diku.dk$',
                                 '^[a-zA-Z0-9_.+-]+@di.ku.dk$']),
                       ('NBI', ['^[a-zA-Z0-9_.+-]+@nbi.ku.dk$',
                                '^[a-zA-Z0-9_.+-]+@nbi.dk$',
                                '^[a-zA-Z0-9_.+-]+@fys.ku.dk$']),
                       ('IMF', ['^[a-zA-Z0-9_.+-]+@math.ku.dk$']),
                       ('DTU', ['^[a-zA-Z0-9_.+-]+@dtu.dk$']),
                       # Keep this KU catch-all last and do not generalize it!
                       ('KU', ['^[a-zA-Z0-9_.+-]+@(alumni.|)ku.dk$']),
                       ]
    force_org_email_dict = dict(force_org_email)
    is_forced_email = False
    is_forced_org = False
    if org.upper() in force_org_email_dict.keys():
        is_forced_org = True
        # Consistent casing
        org = org.upper()
    email_hit = '__BOGUS__'
    for (forced_org, forced_email_list) in force_org_email:
        for forced_email in forced_email_list:
            if re.match(forced_email, email):
                is_forced_email = True
                email_hit = forced_email
                logger.debug('email match on %s vs %s' % (email, forced_email))
                break

        # Use first hit to avoid catch-all overriding specific hits
        if is_forced_email or is_forced_org and org == forced_org:
            break
    if is_forced_org != is_forced_email or \
            not email_hit in force_org_email_dict.get(org, ['__BOGUS__']):
        logger.error('Illegal email and organization combination: %s' %
                     ([email, org, is_forced_org, is_forced_email,
                       email_hit, force_org_email_dict.get(org,
                                                           ['__BOGUS__'])]))
        return False
    else:
        return True
