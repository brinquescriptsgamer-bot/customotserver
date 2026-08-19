-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE DE PASTAS - PARTE 1 DE 3
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- Links base apontando diretamente para a raiz da sua estrutura de pastas do GitHub
local URL_BASE_REPOSITORIO = "https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/scripts/"

-- 📂 ESTRUTURA COMPLETA BASEADA NAS SUAS PASTAS DO GITHUB
local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
	
	-- ==========================================
	-- MACROS COM PRIORIDADE UM (HEALING)
	-- ==========================================
    { nome = "HEALING BRQ ILUSION",    key = "healingBRQ",    cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_ilusion/healing/healingBRQ.lua" },
		
		
	-- ==========================================
    -- MACROS COM PRIORIDADE DOIS (WAR)
    -- ==========================================
	{ nome = "HEALING BRQ ILUSION",    key = "healingBRQ",    cat = "war",     url = URL_BASE_REPOSITORIO .. "sv_ilusion/war/healingBRQ.lua" },
	
	
	-- ==========================================
	-- MACROS SEM PRIORIDADE (CAVE/TARGET)
    -- ==========================================
     { nome = "MAGIAS S/PK BRQ ILUSION", key = "magiasempkBRQ", cat = "cave_target",         url = URL_BASE_REPOSITORIO .. "sv_ilusion/cave_target/magiasempkBRQ.lua" },


    -- ==========================================
    -- MACROS EXTRAS (EXTRAS)
    -- ==========================================
	{ nome = "MAGIAS S/PK BRQ ILUSION", key = "magiasempkBRQ", cat = "EXTRAS",         url = URL_BASE_REPOSITORIO .. "sv_ilusion/EXTRAS/magiasempkBRQ.lua" }
	
    },
    ["Minimalist"] = {
        -- Aponta exatamente para a pasta 'war' e para o arquivo 'Filtrobattle.lua' da sua foto!
        { nome = "FILTRO BATTLE BRQ",      key = "filtroBattle",  cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_minimalist/war/Filtrobattle.lua" }
    },
    ["Legedy"] = {
        { nome = "WAR LEGEDY COMBAT",       key = "magiasempkBRQ", cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_legend/war/magiasempkBRQ.lua" }
    }
}

-- Seleciona o pacote de tabelas do servidor ativo
local MAPA_MACROS_GUILDA = SCRIPTS_DO_REPOSITORIO[servidorAtivoNoMomento] or {}
-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE DE PASTAS - PARTE 2 DE 3
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
local painelPrincipalSeguranca = widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros")

-- Se a janela principal de seguranca estiver ativa no client, desenha os seletores
if painelPrincipalSeguranca and painelPrincipalSeguranca.listaScroll then
    -- Limpa os botoes do servidor anterior da tela para nao encavalar
    painelPrincipalSeguranca.listaScroll:destroyChildren()

    local ORDEM_CATEGORIAS = { "HEALING", "CAVE/TARGET", "WAR", "EXTRAS" }
    local CORES_CATEGORIAS = { 
        ["HEALING"] = "#44ff44", 
        ["CAVE/TARGET"] = "#00bfff", 
        ["WAR"] = "#ff4444", 
        ["EXTRAS"] = "#e6bc22" 
    }

    -- Monta a interface categórica baseada nos arquivos reais mapeados da sua foto
    for _, nomeCat in ipairs(ORDEM_CATEGORIAS) do
        local div = g_ui.createWidget("Label", painelPrincipalSeguranca.listaScroll)
        div:setText("-- " .. nomeCat .. " --")
        div:setFont("verdana-11px-rounded")
        div:setColor(CORES_CATEGORIAS[nomeCat])
        div:setMarginTop(5)
        div:setMarginBottom(2)

        for _, item in ipairs(MAPA_MACROS_GUILDA) do
            if item.cat == nomeCat then
                -- Inicializa o estado gravado de macros ativos no computador dele
                if configMestre.macrosMarcados[item.key] == nil then 
                    configMestre.macrosMarcados[item.key] = true 
                end

                local box = g_ui.createWidget("CheckBox", painelPrincipalSeguranca.listaScroll)
                box:setText(item.nome)
                box:setFont("verdana-11px-rounded")
                box:setHeight(16)
                box:setChecked(configMestre.macrosMarcados[item.key] == true)
                
                -- Salva a intencao de uso do macro diretamente na memoria RAM
                box.onClick = function(w)
                    local val = not w:isChecked()
                    w:setChecked(val)
                    configMestre.macrosMarcados[item.key] = val
                end
            end
        end
    end
end
-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE DE PASTAS - PARTE 3 DE 3
-- =============================================================================

-- MOTOR DE INJEÇÃO EM ESTEIRA (BAIXA INDIVIDUALMENTE CADA SCRIPT SELECIONADO)
local loteJaEstaSendoBaixado = false

local function executarFilaCustomizadaHTTP(indice)
    -- Interceptor de segurança interligado com o validador principal (new_items.lua)
    if not computadorEstaAutorizado then 
        print("[Seguranca] Sessao nao autorizada. Download de macros abortado.")
        return 
    end
    
    if indice == 1 then 
        if loteJaEstaSendoBaixado then return end 
        loteJaEstaSendoBaixado = true 
    end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque Scripts] Sincronizacao de macros concluda para o servidor: " .. tostring(servidorAtivoNoMomento))
        loteJaEstaSendoBaixado = false 
        return 
    end
    
    -- Checa se a CheckBox desse macro específico está marcada pelo cliente
    if configMestre.macrosMarcados[macroAlvo.key] == true then
        -- Injeta quebra de cache nocache para sempre baixar o script mais atualizado do GitHub
        HTTP.get(macroAlvo.url .. "?nocache=" .. os.time(), function(content, err)
            if not err and content and content ~= "" then
                local script, syntaxErr = loadstring(content)
                if script then 
                    pcall(script) 
                else 
                    print("[Erro Script] Falha ao compilar slot: " .. tostring(macroAlvo.nome) .. " - Erro: " .. tostring(syntaxErr)) 
                end
            end
            -- VELOCIDADE PERFORMANCE: Carrega o próximo macro da pasta após 200 milissegundos
            schedule(200, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        -- Se o macro estiver desmarcado, pula direto para o próximo da fila
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- =============================================================================
-- GATILHO DE ARRANCADA AUTOMÁTICA EM NUVEM (TIMEOUT SEGURO DE 300MS)
-- =============================================================================
schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque] Inicializando download dos scripts da pasta de: " .. tostring(servidorAtivoNoMomento))
        executarFilaCustomizadaHTTP(1)
    else
        -- Proteção comercial: Se não houver acesso ativo para esse OT, limpa a tela dele
        if painelPrincipalSeguranca and painelPrincipalSeguranca.listaScroll then
            painelPrincipalSeguranca.listaScroll:destroyChildren()
        end
    end
end)
