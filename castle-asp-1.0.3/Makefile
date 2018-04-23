# by neodal #
ASP_PACKAGE	= castle-asp
ASP_VERSION	= 1.0.0

SVN_DIR  = /home/castle_svn/
SVN_PACKAGE_DIR = /home/castle_svn/packages

ASP_SOURCES := img/ log/ Readme.txt castle_admin.asp castle_admin_account.asp castle_admin_account_submit.asp castle_admin_backup.asp \
								castle_admin_bottom.asp castle_admin_config.asp castle_admin_config_submit.asp castle_admin_download.asp \
								castle_admin_lib.asp castle_admin_log.asp castle_admin_log_submit.asp castle_admin_login.asp \
								castle_admin_login_submit.asp castle_admin_logout_submit.asp castle_admin_menu.asp castle_admin_policy.asp \
								castle_admin_policy_submit.asp castle_admin_policy_view.asp castle_admin_title.asp castle_admin_top.asp \
								castle_policy_secure.asp castle_policy_tree.asp castle_referee.asp castle_version.asp default.asp \
								default.htm index.htm index.html install.asp install_step1.asp install_step2.asp install_step2_submit.asp \
								install_step3.asp install_step3_submit.asp style.css


all: package_castle-asp 

package_castle-asp: 
	@echo -n "* Packaging CASTLE ASP Version ...                      "
	@mkdir $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)/ 
	@cp -rf $(ASP_SOURCES) $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)/ 
	@rm -rf $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)/.svn
	@rm -rf $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)/img/.svn
	@rm -rf $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)/log/.svn
	@(cd $(SVN_PACKAGE_DIR); zip -q -r $(ASP_PACKAGE)-$(ASP_VERSION).zip $(ASP_PACKAGE))
	@rm -rf $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)
	@svn add $(SVN_PACKAGE_DIR)/$(ASP_PACKAGE)-$(ASP_VERSION).zip --quiet 2> /dev/null
	@echo "[[1;36mDone[0;37m]"

