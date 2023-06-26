### A Pluto.jl notebook ###
# v0.19.25

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ ba1228d9-8b02-4ae1-b1ad-4ac59e52066f
begin
	using Pkg
	Pkg.activate("Project.toml")
	using Revise
	import CooperativeDilemmas as CD
end

# ╔═╡ 5639f340-4f02-4386-9bea-97f1650067c8
begin
	using Distributions
	using Roots
	using Plots
	using PlutoUI
	using LaTeXStrings
	using ColorSchemes
end

# ╔═╡ 8e887e28-cfb5-11ed-248a-c507d7f75b7d
md"# Notebook"

# ╔═╡ 33a06382-047c-4ceb-8c03-e57ae57978b2
md"## Libraries"

# ╔═╡ 6371057c-7669-4039-a6b0-9dd1ed2e072e
palette(:seaborn_colorblind)

# ╔═╡ 2264d73d-6739-4376-b3cb-f80f007e39c6
md"# Figure 1"

# ╔═╡ a258aaf0-ec6c-454a-8480-68551802ea1f
begin
	bfig1 = [0,0,1,1,1,1] # b sequence
	cfig1 = [0,1/3,1/3,1/3,1/3] # c sequence
	nfig1 = length(bfig1)-1 # number of players
	(Cfig1,Dfig1) = CD.PGG(bfig1,cfig1)
end

# ╔═╡ c0f50f12-01bf-4f49-9c9b-219bb7a61954
pl_fig1 = CD.plot_game(Cfig1,Dfig1)

# ╔═╡ 5b839005-d449-4ec7-aabd-e7ae9318e666
savefig(pl_fig1,"./fig1.pdf")

# ╔═╡ c8e7e7e9-256b-46d6-b6ff-f28c3339c48c
md"# Figure 2"

# ╔═╡ 47b4cf39-5a4a-4c26-85e3-ee25080dcf29
md"# Figure 3"

# ╔═╡ 983d0a12-a054-456a-8b20-a68af7aea527
begin
	v_congestion = [1,1,1,0,0,0]
	n_congestion = length(v_congestion)
	γ_congestion = 1/3
	k_congestion = range(0,stop=1,length=n_congestion)
	(C_congestion,D_congestion) = CD.congestion_games(v_congestion,γ_congestion)
end

# ╔═╡ 5f1506f3-a496-4303-bd85-7d1b6523bda2
pl_congestion = CD.plot_game(C_congestion,D_congestion)

# ╔═╡ 381f332b-7d95-4483-853b-76813047cad8
savefig(pl_congestion,"./fig3.pdf")

# ╔═╡ da258c6e-ca81-49ff-88da-b57e5825726e
md"# Figure 4"

# ╔═╡ 0f73d955-37ce-4b7a-b48b-6399f4fbcd1e
begin
	v_club = [0,0,0,1,1,1]
	n_club = length(v_club)-1
	γ_club = 1/3
	(C_club,D_club) = CD.CGG(v_club,γ_club)
end

# ╔═╡ 3dc356e3-b64a-41e1-9375-d24516ac9346
pl_club = CD.plot_game(C_club,D_club)

# ╔═╡ 37bfa624-5ac4-41cf-bcaf-6f7706291237
savefig(pl_club,"./fig4.pdf")

# ╔═╡ 00b48a1d-7617-41ed-bd91-587415390585
md"# Figure 5"

# ╔═╡ c04bb1ad-cf92-4055-83c4-6a2b2389f02e
begin
	b_threshold = [0,0,0,1,1,1,1]
	n_threshold = length(b_threshold)-1
	c_threshold = (1/7) .* ones(n_threshold)
	(C_threshold,D_threshold) = CD.PGG(b_threshold,c_threshold)
end

# ╔═╡ c204a602-e4d3-4e67-a555-54dec83e6ade
pl_threshold = CD.plot_game(C_threshold,D_threshold)

# ╔═╡ 64746d8c-ead4-44ae-ba35-4bbedcba8c8f
savefig(pl_threshold,"./fig5.pdf")

# ╔═╡ 6bc59fc2-0f8c-4399-943b-9a40bd183a47
md"# Figure 6"

# ╔═╡ dfbe9249-3f93-4828-b8dd-bb352606220e
begin
	C₁ = [0,1,1.1]
	C₂ = [0,1,1.2]
	D = [1,2,1]
	G₁ = C₁-D
	G₂ = C₂-D
	T₁ = CD.total_payoffs(C₁,D)
	T₂ = CD.total_payoffs(C₂,D)	
	w₁(x) = CD.poly_Bernstein(x,T₁/3)
	x̂₁ = CD.find_social_optimum(C₁,D)
	w₂(x) = CD.poly_Bernstein(x,T₂/3)
	g₁(x) = CD.poly_Bernstein(x,G₁)
	g₂(x) = CD.poly_Bernstein(x,G₂)
end

# ╔═╡ 9c47e75d-5c8e-4bae-a711-2a83051d2565
CD.find_social_optimum(C₁,D)

# ╔═╡ 37c7a5be-2a33-4f50-b9e0-a7f219c14ceb
begin
	x = range(0, 1, length=100)
	yg₁ = g₁.(x)
	yg₂ = g₂.(x)
	yw₁ = w₁.(x)
	yw₂ = w₂.(x)
	pl_counter = plot(layout=(1,2),size=(600,400))
	# left panel
	plot!(subplot=1,x,yg₂,color=palette(:seaborn_colorblind)[3],linewidth=2,linestyle=:dot,label="\$z=1/5\$",tickfontsize=10,legendfontsize=10)
	plot!(subplot=1,x,yg₁,color=palette(:seaborn_colorblind)[3],linewidth=2,label="\$z=1/10\$",xlabel="probability of cooperating, \$x\$",ylabel="private gain function, \$g(x)\$")
	plot!([0,1],[0,0],color="black",linestyle=:dash,label="")
	plot!(subplot=1,yticks=([-1,0],["\$-1\$","\$0\$"]))
	plot!(subplot=1,xticks=([0,1],["\$x_1^\\ast=0\$","\$x_2^\\ast=1\$"]))
	# right panel
	plot!(subplot=2,x,yw₂,color=palette(:seaborn_colorblind)[5],linewidth=2,linestyle=:dot,label="\$z=1/5\$",tickfontsize=10,legendfontsize=10)
	plot!(subplot=2,x,yw₁,xlabel="probability of cooperating, \$x\$",ylabel="expected average payoff, \$w(x)\$",color=palette(:seaborn_colorblind)[5],linewidth=2,label="\$z=1/10\$")
	plot!(subplot=2,[x̂₁,x̂₁],[1,w₁(x̂₁)],color="black",linestyle=:dash,label="")
	plot!(subplot=2,[0,x̂₁],[w₁(x̂₁),w₁(x̂₁)],color="black",linestyle=:dash,label="")
	plot!(subplot=2,yticks=([1,w₁(x̂₁),1.2],["1","\$w(\\hat{x})\$","1.2"]))
	plot!(subplot=2,xticks=([0,x̂₁,1],["0","\$\\hat{x}\$","1"]))
end

# ╔═╡ 910c41eb-8287-48b8-ac6e-b000759beb51
begin
	k = range(0,stop=1,length=3)
	Cexample1 = [0.5,1,2]
	Dexample1 = [-.5,1.25,1.5]
	Gexample1 = Cexample1 .- Dexample1
	Texample1 = CD.total_payoffs(Cexample1,Dexample1)
	gexample1(x) = CD.poly_Bernstein(x,Gexample1)
	wexample1(x) = CD.poly_Bernstein(x,Texample1/3)
	ygexample1 = gexample1.(x)
	pl_example1 = plot(layout=(1,2),size=(600,400))
	# left panel
	plot!(subplot=1,tickfontsize=10,legendfontsize=10)
	plot!(subplot=1,[0,1],[0,0],color="black",linestyle=:dash,label="")
	plot!(subplot=1,xticks=(k,["0","1","2"]),xlabel="number of \$\\mathcal{C}\$ co-players, \$k\$",ylabel="payoffs")
	plot!(subplot=1,k,Cexample1,linestyle=:dash,linewidth=2,markershape=:circle,markersize=5,color=palette(:seaborn_colorblind)[1],label="\$C_k\$")
	plot!(subplot=1,k,Dexample1,linestyle=:dash,linewidth=2,markershape=:rect,markersize=5,color=palette(:seaborn_colorblind)[4],label="\$D_k\$")
	plot!(subplot=1,k,Gexample1,linestyle=:dash,linewidth=2,markershape=:utriangle,markersize=5,color=palette(:seaborn_colorblind)[3],label="\$G_k\$")
	# right panel
	plot!(subplot=2,tickfontsize=10,legendfontsize=10)	
	plot!(subplot=2,xticks=([0,1],["0","\$\\hat{x}=x^\\ast\$"]))
	plot!(subplot=2,x,ygexample1,color=palette(:seaborn_colorblind)[3],linewidth=2,label="\$g(x)\$",xlabel="probability of cooperating, \$x\$",ylabel="payoff")
	plot!(subplot=2,x,wexample1,color=palette(:seaborn_colorblind)[5],linewidth=2,linestyle=:dot,label="\$w(x)\$")
	plot!(subplot=2,[0,1],[0,0],color="black",linestyle=:dash,label="")	
end

# ╔═╡ 0b25bc91-076f-45fc-82eb-1f2eb272a5e5
savefig(pl_example1,"./fig2.pdf")

# ╔═╡ b3ea2839-c80f-427e-a1ad-5382be752d93
savefig(pl_counter,"./fig6.pdf")

# ╔═╡ 57e600e5-9d1c-4739-b68d-c476c826c6c5
begin
	S1 = CD.social_gains(C₁,D)
	s1(x) = CD.poly_Bernstein(x,S1)
	find_zeros(s1,0.,1.)[1]
end

# ╔═╡ 048f335d-f9ae-4332-a069-c29086ae4dc4
z_slider = @bind z Slider(0:.01:1,show_value=true)

# ╔═╡ ed1c5cd3-00c2-42e1-bb50-cdc6536a9d98
CD.plot_example_12(z)

# ╔═╡ Cell order:
# ╠═8e887e28-cfb5-11ed-248a-c507d7f75b7d
# ╠═33a06382-047c-4ceb-8c03-e57ae57978b2
# ╠═ba1228d9-8b02-4ae1-b1ad-4ac59e52066f
# ╠═5639f340-4f02-4386-9bea-97f1650067c8
# ╠═6371057c-7669-4039-a6b0-9dd1ed2e072e
# ╠═2264d73d-6739-4376-b3cb-f80f007e39c6
# ╠═a258aaf0-ec6c-454a-8480-68551802ea1f
# ╠═c0f50f12-01bf-4f49-9c9b-219bb7a61954
# ╠═5b839005-d449-4ec7-aabd-e7ae9318e666
# ╠═c8e7e7e9-256b-46d6-b6ff-f28c3339c48c
# ╠═910c41eb-8287-48b8-ac6e-b000759beb51
# ╠═0b25bc91-076f-45fc-82eb-1f2eb272a5e5
# ╠═47b4cf39-5a4a-4c26-85e3-ee25080dcf29
# ╠═983d0a12-a054-456a-8b20-a68af7aea527
# ╠═5f1506f3-a496-4303-bd85-7d1b6523bda2
# ╠═381f332b-7d95-4483-853b-76813047cad8
# ╠═da258c6e-ca81-49ff-88da-b57e5825726e
# ╠═0f73d955-37ce-4b7a-b48b-6399f4fbcd1e
# ╠═3dc356e3-b64a-41e1-9375-d24516ac9346
# ╠═37bfa624-5ac4-41cf-bcaf-6f7706291237
# ╠═00b48a1d-7617-41ed-bd91-587415390585
# ╠═c04bb1ad-cf92-4055-83c4-6a2b2389f02e
# ╠═c204a602-e4d3-4e67-a555-54dec83e6ade
# ╠═64746d8c-ead4-44ae-ba35-4bbedcba8c8f
# ╠═6bc59fc2-0f8c-4399-943b-9a40bd183a47
# ╠═dfbe9249-3f93-4828-b8dd-bb352606220e
# ╠═9c47e75d-5c8e-4bae-a711-2a83051d2565
# ╠═37c7a5be-2a33-4f50-b9e0-a7f219c14ceb
# ╠═b3ea2839-c80f-427e-a1ad-5382be752d93
# ╠═57e600e5-9d1c-4739-b68d-c476c826c6c5
# ╠═048f335d-f9ae-4332-a069-c29086ae4dc4
# ╠═ed1c5cd3-00c2-42e1-bb50-cdc6536a9d98
