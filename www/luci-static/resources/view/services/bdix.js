'use strict';
'require form';
'require fs';
'require ui';

return L.view.extend({
	load: function() {
		return Promise.all([
			L.resolveDefault(fs.exec('/etc/init.d/bdix', ['enabled']), { code: 1 }),
			L.resolveDefault(fs.exec('/etc/init.d/bdix', ['running']), { code: 1 })
		]);
	},

	handleServiceAction: function(action, ev) {
		return fs.exec('/etc/init.d/bdix', [action]).then(function(res) {
			if (res.code !== 0)
				throw new Error((res.stderr || res.stdout || _('Command failed')).trim());

			location.reload();
		}).catch(function(err) {
			ui.addTimeLimitedNotification(null,
				E('p', _('Failed to execute service action: ') + err.message),
				10000, 'danger');
		});
	},

	renderServiceControls: function(isEnabled, isRunning) {
		var button = L.bind(function(action, label, style, disabled) {
			return E('button', {
				'class': 'btn cbi-button-%s'.format(style || 'action'),
				'click': ui.createHandlerFn(this, 'handleServiceAction', action),
				'disabled': disabled ? '' : null
			}, label);
		}, this);

		return E('div', { 'class': 'cbi-section' }, [
			E('h3', _('Service Control')),

			E('div', { 'class': 'cbi-value' }, [
				E('label', { 'class': 'cbi-value-title' }, _('Boot Status')),
				E('div', { 'class': 'cbi-value-field' }, [
					button('enable', _('Enable'), 'positive', isEnabled),
					' ',
					button('disable', _('Disable'), 'negative', !isEnabled)
				])
			]),

			E('div', { 'class': 'cbi-value' }, [
				E('label', { 'class': 'cbi-value-title' }, _('Service Status')),
				E('div', { 'class': 'cbi-value-field' }, [
					button('start', _('Start'), 'positive', isRunning),
					' ',
					button('restart', _('Restart'), 'reload', !isRunning),
					' ',
					button('stop', _('Stop'), 'negative', !isRunning)
				])
			])
		]);
	},

	render: function(data) {
		var m, s, o;
		var isEnabled = data[0].code === 0;
		var isRunning = data[1].code === 0;

		m = new form.Map('bdix', _('BDIX Proxy Configuration'),
			_('Configure transparent redirect routing over SOCKS4/SOCKS5 proxies for BDIX bypass.'));

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

		return m.render().then(L.bind(function(node) {
			node.insertBefore(this.renderServiceControls(isEnabled, isRunning), node.firstChild);
			return node;
		}, this));
	}
});
