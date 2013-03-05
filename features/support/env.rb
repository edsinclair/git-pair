require 'tmpdir'
require 'test/unit/assertions'
World(Test::Unit::Assertions)


module RepositoryHelper
  # TODO: use 1.8.7's Dir.mktmpdir?
  TEST_REPO_PATH         = File.join(Dir::tmpdir, "git-pair-test-repo")
  TEST_REPO_DOT_GIT_PATH = "#{TEST_REPO_PATH}/.git"

  PROJECT_PATH       = File.join(File.dirname(__FILE__), "../..")
  GIT_PAIR           = "#{PROJECT_PATH}/bin/git-pair"
  CONFIG_BACKUP_PATH = "#{PROJECT_PATH}/tmp"

  def git_pair(options = "")
    output = `HOME=#{TEST_REPO_PATH} GIT_DIR=#{TEST_REPO_DOT_GIT_PATH} #{GIT_PAIR} #{options} 2>&1`
    output.gsub(/\e\[\d\d?m/, '')  # strip any ANSI colors
  end

  def git_config(options = nil)
    options ||= "--list"
    `HOME=#{TEST_REPO_PATH} GIT_DIR=#{TEST_REPO_DOT_GIT_PATH} git config #{options} 2>&1`
  end

  def backup_gitconfigs
    FileUtils.mkdir_p CONFIG_BACKUP_PATH
    backup_user_gitconfig
    FileUtils.cp "#{PROJECT_PATH}/.git/config", "#{CONFIG_BACKUP_PATH}/config.backup"
  end

  def restore_gitconfigs
    FileUtils.cp "#{CONFIG_BACKUP_PATH}/config.backup", "#{PROJECT_PATH}/.git/config"
    restore_user_gitconfig
    FileUtils.rm_rf CONFIG_BACKUP_PATH
  end

  def backup_user_gitconfig
    FileUtils.cp(gitconfig_path, gitconfig_backup_path) if File.exists?(gitconfig_path)
  end

  def restore_user_gitconfig
    FileUtils.cp(gitconfig_backup_path, gitconfig_path) if File.exists?(gitconfig_backup_path)
  end

  def gitconfig_backup_path
    @gitconfig_backup_path ||= File.join(CONFIG_BACKUP_PATH, ".gitconfig.backup")
  end

  def gitconfig_path
    @gitconfig_path ||= File.expand_path(File.join("~", ".gitconfig"))
  end
end

World(RepositoryHelper)

Before do
  backup_gitconfigs
  FileUtils.mkdir_p RepositoryHelper::TEST_REPO_DOT_GIT_PATH
  `GIT_DIR=#{RepositoryHelper::TEST_REPO_DOT_GIT_PATH} && git init`
end

After do
  FileUtils.rm_rf RepositoryHelper::TEST_REPO_PATH
  restore_gitconfigs
end
