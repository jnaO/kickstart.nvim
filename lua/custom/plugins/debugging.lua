local pythonPath = function()
  local cwd = '/Users/jnao/Code/home-automator/django/.venv/bin/python'
  return cwd
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap, dapui = require 'dap', require 'dapui'

    require('dapui').setup()

    local set_python_dap = function()
      require('dap-python').setup() -- earlier so setup the various defaults ready to be replaced
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = pythonPath(),
        },
        {
          type = 'python',
          request = 'launch',
          name = '1 Django',
          program = '/Users/jnao/Code/home-automator/django/manage.py',
          args = { 'runserver', '--noreload', '0.0.0.0:8000' },
          justMyCode = true,
          django = true,
          console = 'integratedTerminal',
        },
        {
          type = 'python',
          request = 'attach',
          name = 'Attach remote',
          connect = function()
            return {
              host = '127.0.0.1',
              port = 5678,
            }
          end,
        },
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file with arguments',
          program = '${file}',
          args = function()
            local args_string = vim.fn.input 'Arguments: '
            return vim.split(args_string, ' +')
          end,
          console = 'integratedTerminal',
          pythonPath = pythonPath(),
        },
      }

      dap.adapters.python = {
        type = 'executable',
        command = pythonPath(),
        args = { '-m', 'debugpy.adapter' },
      }
    end
    set_python_dap()
    vim.api.nvim_create_autocmd({ 'DirChanged' }, {
      callback = function()
        set_python_dap()
      end,
    })

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set('n', '<F5>', dap.continue, {})
    vim.keymap.set('n', '<F10>', dap.step_over, {})
    vim.keymap.set('n', '<F11>', dap.step_into, {})
    vim.keymap.set('n', '<F12>', dap.step_out, {})
    vim.keymap.set('n', 'äb', dap.toggle_breakpoint, {})
    vim.keymap.set('n', 'äB', dap.set_breakpoint, {})
    vim.keymap.set('n', 'äc', dap.continue, {})
  end,
}
