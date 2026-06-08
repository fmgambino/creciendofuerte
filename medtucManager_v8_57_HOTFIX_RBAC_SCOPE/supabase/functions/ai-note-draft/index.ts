import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });

  try {
    const apiKey = Deno.env.get("OPENAI_API_KEY");
    if (!apiKey) {
      return new Response(JSON.stringify({ error: "OPENAI_API_KEY no configurada" }), {
        status: 503,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const payload = await req.json();
    const mode = payload?.mode === "improve" ? "mejorar" : "redactar";
    const order = payload?.order || {};
    const currentText = String(payload?.current_text || "");

    const prompt = [
      `Tarea: ${mode} una nota institucional formal en espanol argentino.`,
      "No inventes datos. Usa solo la informacion provista. No incluyas importes.",
      "Debe ser clara, breve, administrativa y tecnica.",
      "",
      `Orden: ${order.number || "-"}`,
      `Oficina: ${order.office || "-"}`,
      `Direccion: ${order.address || "-"}`,
      `Solicitante: ${order.requester || "-"}`,
      `Tecnico: ${order.technician || "-"}`,
      `Equipo: ${order.equipment || "-"}`,
      `Falla: ${order.fault || "-"}`,
      `Informe tecnico: ${order.technical_report || "-"}`,
      `Solucion: ${order.solution || "-"}`,
      `Accesorios/Insumos: ${order.accessories || "-"}`,
      currentText ? `Texto actual a mejorar:\n${currentText}` : "",
    ].filter(Boolean).join("\n");

    const response = await fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: Deno.env.get("OPENAI_MODEL") || "gpt-4.1-mini",
        input: prompt,
        temperature: 0.2,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      return new Response(JSON.stringify({ error: errorText }), {
        status: response.status,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const data = await response.json();
    const text = data.output_text || data.output?.flatMap((x: any) => x.content || []).map((c: any) => c.text || "").join("").trim();

    return new Response(JSON.stringify({ text }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: String(error?.message || error) }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
