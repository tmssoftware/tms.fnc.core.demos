# TMS FNC Core - AI Menu Studio

A restaurant designs its menu card with the AI service (TTMSFNCAIService) and the AI interaction controls: ask for a change in your own words, review the plan in TTMSFNCAIPlanView, hold TTMSFNCAIPreviewLens to see it on the card, apply it or one step at a time, undo it in one go; a vague request gets TTMSFNCAIChoiceCards first; the style fields are TTMSFNCAIPromptEdit (a value or a phrase); TTMSFNCAIDropZone takes a CSV of dishes, an image or a text.

No key and no network: the service talks to an OpenAI-compatible model whose answers the demo writes itself (TDemoModel, the Transport of the service). Set Service.DefaultProfile to a real provider to use a real model. FMX, VCL and WEB (in the browser a real provider is reached through a proxy URL of your server and the drop zone takes the sample CSV as text: it has no file dialog and takes no dropped files there).
