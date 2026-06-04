select(
  (.goal | test($w; "i")) or
  (.context | test($w; "i")) or
  (.subtasks[]?.goal | test($w; "i")) or
  (.subtasks[]?.context | test($w; "i"))
) | "\(.id) [\(.status)] \(.goal)"
