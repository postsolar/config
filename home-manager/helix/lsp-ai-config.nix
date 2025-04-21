# TODO: set up with more models + RAGs

let

  # ~ models

  groq = {
    type = "open_ai";
    chat_endpoint = "https://api.groq.com/openai/v1/chat/completions";
    model = "llama3-70b-8192";
    auth_token_env_var_name = "GROQ_API_KEY";
    max_requests_per_second = 0.1;
  };

  # ~ chat actions

  chatNoContext = {
    trigger = "!C";
    action_display_name = "Chat";
    model = "groq";
    parameters = {
      max_context = 4096;
      max_tokens = 1024;
      system = "You are a code assistant chatbot. The user will ask you for assistance and you will do your best to answer succinctly and accurately. When including code blocks delimited by three backticks (```), make sure to also tag the language the block represents (for example, ```typescript).";
    };
  };

  # apparently this thing requires a VectorStore backend, which is implemented but completely undocumented
  # won't work with current setup
  #
  # chatWithContext = {
  #   trigger = "!CC";
  #   action_display_name = "Chat with context";
  #   model = "groq";
  #   parameters = {
  #     max_context = 4096;
  #     max_tokens = 1024;
  #     system = "You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately given the code context:\n\n{CONTEXT}";
  #   };
  # };

  # ~ code actions

  complete = {
    action_display_name = "Complete";
    model = "groq";
    parameters = {
      max_context = 4096;
      max_tokens = 4096;
    };
    system = builtins.readFile ./prompts/complete.md;
    messages = [{ role = "user"; content = "{CODE}"; }];
    post_process = { extractor = "(?s)<answer>(.*?)</answer>"; };
  };

in

{
  initializationOptions = {

    memory.file_store = {};

    models = {
      inherit groq;
    };

    chat = [
      chatNoContext
      # chatWithContext
    ];

    actions = [ complete ];

  };
}

