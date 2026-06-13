'use strict';
'require form';
'require fs';
'require ui';

return L.view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('bdix', _('BDIX Proxy Configuration'),
			_('Configure transparent redirect routing over SOCKS4/SOCKS5 proxies for BDIX bypass.'));

		// Global Section
		s = m.section(form.NamedSection, 'global', 'bdix', _('Global Configuration'));
		s.anonymous = true;

		// Service Enable Switch
		o = s.option(form.Flag, 'enabled', _('Enable BDIX Service'), _('Start/stop the BDIX proxy daemon.'));
		o.rmempty = false;

		// Start Button
		o = s.option(form.Button, '_start', _('Start Service'), _('Manually start the BDIX daemon and apply redirect rules.'));
		o.inputstyle = 'apply';
		o.inputtitle = _('Start Service');
		o.onclick = function(ev) {
			return fs.exec('/etc/init.d/bdix', ['start']).then(function(res) {
				ui.addNotification(null, E('p', _('BDIX service started successfully.')), 'info');
			}).catch(function(err) {
				ui.addNotification(null, E('p', _('Failed to start BDIX service: ') + err.message), 'danger');
			});
		};

		// Stop Button
		o = s.option(form.Button, '_stop', _('Stop Service'), _('Manually stop the BDIX daemon and flush redirect rules.'));
		o.inputstyle = 'reset';
		o.inputtitle = _('Stop Service');
		o.onclick = function(ev) {
			return fs.exec('/etc/init.d/bdix', ['stop']).then(function(res) {
				ui.addNotification(null, E('p', _('BDIX service stopped successfully.')), 'info');
			}).catch(function(err) {
				ui.addNotification(null, E('p', _('Failed to stop BDIX service: ') + err.message), 'danger');
			});
		};

		// Restart Button
		o = s.option(form.Button, '_restart', _('Restart Service'), _('Manually restart the BDIX daemon and refresh redirect rules.'));
		o.inputstyle = 'reload';
		o.inputtitle = _('Restart Service');
		o.onclick = function(ev) {
			return fs.exec('/etc/init.d/bdix', ['restart']).then(function(res) {
				ui.addNotification(null, E('p', _('BDIX service restarted successfully.')), 'info');
			}).catch(function(err) {
				ui.addNotification(null, E('p', _('Failed to restart BDIX service: ') + err.message), 'danger');
			});
		};

		// Connection Settings Section
		s = m.section(form.NamedSection, 'connection', 'bdix', _('Proxy Server Settings'));
		s.anonymous = true;

		// Remote IP/Domain
		o = s.option(form.Value, 'ip', _('Proxy Server IP/Host'), _('The IP address or domain name of the remote proxy server.'));
		o.datatype = 'host';
		o.placeholder = '192.168.100.1';
		o.rmempty = false;

		// Remote Port
		o = s.option(form.Value, 'port', _('Proxy Server Port'), _('The connection port of the remote proxy server.'));
		o.datatype = 'port';
		o.placeholder = '1080';
		o.rmempty = false;

		// Proxy Type
		o = s.option(form.ListValue, 'type', _('Proxy Protocol Type'));
		o.value('socks5', 'SOCKS5');
		o.value('socks4', 'SOCKS4');
		o.value('http-connect', 'HTTP CONNECT (Squid)');
		o.value('http-relay', 'HTTP RELAY');
		o.default = 'socks5';

		// Authentication Username
		o = s.option(form.Value, 'login', _('Authentication Username'), _('Leave blank if authentication is not required.'));
		o.rmempty = true;

		// Authentication Password
		o = s.option(form.Value, 'password', _('Authentication Password'), _('Leave blank if authentication is not required.'));
		o.password = true;
		o.rmempty = true;

		// Direct Connection (Bypass) Settings Section
		s = m.section(form.NamedSection, 'connection', 'bdix', _('Direct Connection (Bypass) Settings'),
			_('Configure domains or IP addresses that should bypass the proxy and connect directly. Note: You must restart the BDIX service to apply changes to these bypass rules.'));
		s.anonymous = true;

		o = s.option(form.DynamicList, 'bypass_domain', _('Bypass Domains'), _('Direct connection for specific domains (e.g. facebook.com).'));
		o.datatype = 'host';
		o.placeholder = 'wise.com';

		o = s.option(form.DynamicList, 'bypass_ip', _('Bypass IPs / Subnets'), _('Direct connection for specific IPs or subnets (e.g. 172.16.50.7 or 192.168.100.0/24).'));
		o.datatype = 'ipaddr';
		o.placeholder = '172.16.50.7';

		// Local / Redirection Settings Section
		s = m.section(form.NamedSection, 'connection', 'bdix', _('Advanced / Redirection Settings'));
		s.anonymous = true;

		// Local Listen IP
		o = s.option(form.Value, 'local_ip', _('Local Listen IP'), _('IP address Redsocks listens on locally. (0.0.0.0 listens on all interfaces)'));
		o.datatype = 'ip4addr';
		o.default = '0.0.0.0';
		o.rmempty = false;

		// Local Listen Port
		o = s.option(form.Value, 'local_port', _('Local Listen Port'), _('Local redirection port. MUST match the ports defined in firewall redirect rules.'));
		o.datatype = 'port';
		o.default = '1337';
		o.rmempty = false;

		// Interface
		o = s.option(form.Value, 'interface', _('Redirect Interface'), _('LAN interface to capture outbound traffic from. (Default: br-lan)'));
		o.default = 'br-lan';
		o.rmempty = false;

		return m.render();
	}
});
