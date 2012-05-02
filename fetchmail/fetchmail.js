/******
 *
 *	Fetchmail Roundcube Plugin (RC0.4 and above), Backend: MySQL to Fetchmail
 *	Developped by Arthur Mayer, a.mayer@citex.net
 *	Released under GPL license (http://www.gnu.org/licenses/gpl.txt)
 *
******/

if (window.rcmail) {
	rcmail.addEventListener('init', function(evt) {

	var tab = $('<span>').attr('id', 'settingstabplugin_fetchmail').addClass('tablink'); 
	var button = $('<a>').attr('href', rcmail.env.comm_path+'&_action=plugin.fetchmail').html(rcmail.gettext('fetchmail','fetchmail')).appendTo(tab);
	button.bind('click', function(e){ return rcmail.command('plugin.fetchmail', this) });

	// add button and register commands
	rcmail.add_element(tab, 'tabs');
	rcmail.register_command('plugin.fetchmail', function() { rcmail.goto_url('plugin.fetchmail') }, true);

	rcmail.register_command('plugin.fetchmail.save', function() {
		var input_server = rcube_find_object('_fetchmailserver');
		var input_user = rcube_find_object('_fetchmailuser');
		var input_pass = rcube_find_object('_fetchmailpass');
		if(input_server.value == "" || input_user.value == "" || input_pass.value == ""){
			parent.rcmail.display_message(rcmail.gettext('textempty','fetchmail'), 'error');    
		} else {
			document.forms.fetchmailform.submit();
		}
	}, true);

	})
}

function fetchmail_edit(id){
	window.location.href = '?_task=settings&_action=plugin.fetchmail&_id='+id;
}

function row_del(id) {
	if(id == "") {
		parent.rcmail.display_message(rcmail.gettext('textempty','fetchmail'), 'error');
	}
	else {
		document.getElementById('fetch-table').deleteRow(document.getElementById('fetch_'+id).rowIndex);
		rcmail.http_request('plugin.fetchmail.del', '_id='+id, true);
		if(document.getElementById('fetch-table').getElementsByTagName("TBODY").item(0).rows.length == 0) {
			var tbody = document.getElementById('fetch-table').getElementsByTagName("TBODY").item(0);
			var row=document.createElement("TR");
			var cell = document.createElement("TD");
			var text=document.createTextNode(rcmail.gettext('nofetch','fetchmail'));
			cell.setAttribute('colspan', '4');
			cell.appendChild(text);
			row.appendChild(cell);
			tbody.appendChild(row);
		}
		parent.rcmail.display_message(rcmail.gettext('successfullydeleted','fetchmail'), 'confirmation');
	}
}

function row_edit(id, active) {
	if(id == "") {
		parent.rcmail.display_message(rcmail.gettext('textempty','fetchmail'), 'error');
	}
	else {
		if(active == 1) {
			var active = 0;
			document.getElementById('td_'+id).setAttribute('onclick', 'row_edit('+id+','+active+');');
			document.getElementById('img_'+id).src = 'plugins/fetchmail/skins/default/disabled.png';
			rcmail.http_request('plugin.fetchmail.disable', '_id='+id, true);
			parent.rcmail.display_message(rcmail.gettext('successfullydisabled','fetchmail'), 'confirmation');
		}
		else {
			var active = 1;
			document.getElementById('td_'+id).setAttribute('onclick', 'row_edit('+id+','+active+');');
			document.getElementById('img_'+id).src = 'plugins/fetchmail/skins/default/enabled.png';
			rcmail.http_request('plugin.fetchmail.enable', '_id='+id, true);
			parent.rcmail.display_message(rcmail.gettext('successfullyenabled','fetchmail'), 'confirmation');
		}
	}
}