.. include:: ../defs.hrst

.. only:: html

   :math:`\newcommand{\PC}{P_{\mathrm{C}}}`
   :math:`\newcommand{\QC}{Q_{\mathrm{C}}}`
   :math:`\newcommand{\QN}{Q_{\mathrm{N}}}`
   :math:`\newcommand{\QP}{Q_{\mathrm{P}}}`
   :math:`\newcommand{\QFe}{Q_{\mathrm{Fe}}}`
   :math:`\newcommand{\QCess}{Q_{\mathrm{C}}^{\mathrm{ess}}}`
   :math:`\newcommand{\QNess}{Q_{\mathrm{N}}^{\mathrm{ess}}}`
   :math:`\newcommand{\QPess}{Q_{\mathrm{P}}^{\mathrm{ess}}}`
   :math:`\newcommand{\QFeess}{Q_{\mathrm{Fe}}^{\mathrm{ess}}}`
   :math:`\newcommand{\maintConsum}{{m}}`
   :math:`\newcommand{\ECoiiProd}{{E}}`
   :math:`\newcommand{\VImax}{{V^{\max}_{\mathrm{I}}}}`
   :math:`\newcommand{\Sf}{{S_{\mathrm{f}}}}`
   :math:`\newcommand{\AI}{{A_{\mathrm{I}}}}`
   :math:`\newcommand{\RQ}{{R_Q}}`
   :math:`\newcommand{\QNprotot}{{Q_{\mathrm{N}}^{\mathrm{Pro\,tot}}}}`
   :math:`\newcommand{\QPRNAmin}{{Q_{\mathrm{P,min}}^{\mathrm{RNA}}}}`
   :math:`\newcommand{\QNRNAmin}{{Q_{\mathrm{N,min}}^{\mathrm{RNA}}}}`
   :math:`\newcommand{\QNstomax}{{Q_{\mathrm{N,max}}^{\mathrm{Sto}}}}`
   :math:`\newcommand{\QPother}{{Q_{\mathrm{P}}^{\mathrm{Other}}}}`
   :math:`\newcommand{\QPthy}{{Q_{\mathrm{P}}^{\mathrm{Thy}}}}`
   :math:`\newcommand{\QCthy}{{Q_{\mathrm{C}}^{\mathrm{Thy}}}}`
   :math:`\newcommand{\QCother}{{Q_{\mathrm{C}}^{\mathrm{Other}}}}`
   :math:`\newcommand{\QCproother}{{Q_{\mathrm{C}}^{\mathrm{Pro\_Other}}}}`
   :math:`\newcommand{\QCchl}{{Q_{\mathrm{C}}^{\mathrm{Chl}}}}`
   :math:`\newcommand{\QNDNAactl}{{Q_{\mathrm{N}}^{\mathrm{DNA\_actl}}}}`
   :math:`\newcommand{\QPDNAactl}{{Q_{\mathrm{P}}^{\mathrm{DNA\_actl}}}}`
   :math:`\newcommand{\QNproactl}{{Q_{\mathrm{N}}^{\mathrm{Pro\_actl}}}}`
   :math:`\newcommand{\QPotheractl}{{Q_{\mathrm{P}}^{\mathrm{Other\_actl}}}}`
   :math:`\newcommand{\QCDNA}{{Q_{\mathrm{C}}^{\mathrm{DNA}}}}`
   :math:`\newcommand{\QCRNA}{{Q_{\mathrm{C}}^{\mathrm{RNA}}}}`
   :math:`\newcommand{\QCRNAmin}{{Q_{\mathrm{C,min}}^{\mathrm{RNA}}}}`
   :math:`\newcommand{\QNstore}{{Q_{\mathrm{N}}^{\mathrm{Sto}}}}`
   :math:`\newcommand{\QPstore}{{Q_{\mathrm{P}}^{\mathrm{Sto}}}}`
   :math:`\newcommand{\QFestore}{{Q_{\mathrm{Fe}}^{\mathrm{Sto}}}}`
   :math:`\newcommand{\Qpmax}{{Q_{\mathrm{P}}^{\mathrm{max}}}}`
   :math:`\newcommand{\Qfemax}{{Q_{\mathrm{Fe}}^{\mathrm{max}}}}`
   :math:`\newcommand{\YCPPlip}{{Y^{\mathrm{C}:\mathrm{P}}_{\mathrm{Plip}}}}`
   :math:`\newcommand{\YCNprotein}{{Y^{\mathrm{C}:\mathrm{N}}_{\mathrm{Pro}}}}`
   :math:`\newcommand{\YCNDNA}{{Y^{\mathrm{C}:\mathrm{N}}_{\mathrm{DNA}}}}`
   :math:`\newcommand{\YCNRNA}{{Y^{\mathrm{C}:\mathrm{N}}_{\mathrm{RNA}}}}`
   :math:`\newcommand{\YCNcyano}{{Y^{\mathrm{C}:\mathrm{N}}_{\mathrm{Nsto}}}}`
   :math:`\newcommand{\YNCchl}{{Y^{\mathrm{N}:\mathrm{C}}_{\mathrm{Chl}}}}`
   :math:`\newcommand{\YPNnucacid}{{Y^{\mathrm{P}:\mathrm{N}}_{\mathrm{RNA}}}}`
   :math:`\newcommand{\YTHYP}{{Y^{\mathrm{P}}_{\mathrm{Thy}}}}`
   :math:`\newcommand{\Athy}{{A_{\mathrm{Thy}}}}`
   :math:`\newcommand{\YFeNphoto}{{Y^{\mathrm{Fe}:\mathrm{N}}_{\mathrm{Pho}}}}`
   :math:`\newcommand{\Apho}{{A_{\mathrm{Pho}}}}`
   :math:`\newcommand{\Abio}{{A_{\mathrm{Bio}}}}`
   :math:`\newcommand{\APRNA}{{A^{\mathrm{P}}_{\mathrm{RNA}}}}`
   :math:`\newcommand{\ANRNA}{{A^{\mathrm{N}}_{\mathrm{RNA}}}}`
   :math:`\newcommand{\macromolTempFunc}{{f^{\mathrm{mm}}(T)}}`
   :math:`\newcommand{\QCphoto}{{Q_{\mathrm{C}}^{\mathrm{Pro\_Pho}}}}`
   :math:`\newcommand{\QNphoto}{{Q_{\mathrm{N}}^{\mathrm{Pro\_Pho}}}}`
   :math:`\newcommand{\QCbio}{{Q_{\mathrm{C}}^{\mathrm{Pro\_Bio}}}}`
   :math:`\newcommand{\QNbio}{{Q_{\mathrm{N}}^{\mathrm{Pro\_Bio}}}}`
   :math:`\newcommand{\QNchl}{{Q_{\mathrm{N}}^{\mathrm{Chl}}}}`
   :math:`\newcommand{\QNpro}{{Q_{\mathrm{N}}^{\mathrm{Pro}}}}`
   :math:`\newcommand{\QCpro}{{Q_{\mathrm{C}}^{\mathrm{Pro}}}}`
   :math:`\newcommand{\QNproother}{{Q_{\mathrm{N}}^{\mathrm{Pro\_Other}}}}`
   :math:`\newcommand{\QNDNA}{{Q_{\mathrm{N}}^{\mathrm{DNA}}}}`
   :math:`\newcommand{\QPDNA}{{Q_{\mathrm{P}}^{\mathrm{DNA}}}}`
   :math:`\newcommand{\QNRNA}{{Q_{\mathrm{N}}^{\mathrm{RNA}}}}`
   :math:`\newcommand{\QPRNA}{{Q_{\mathrm{P}}^{\mathrm{RNA}}}}`
   :math:`\newcommand{\Qfephoto}{{Q_{\mathrm{Fe}}^{\mathrm{Pro\_Pho}}}}`
   :math:`\newcommand{\QnNoChl}{{Q_{\mathrm{N}}^{\text{no-Chl}}}}`
   :math:`\newcommand{\QpNoChl}{{Q_{\mathrm{P}}^{\text{no-Chl}}}}`
   :math:`\newcommand{\QfeNoChl}{{Q_{\mathrm{Fe}}^{\text{no-Chl}}}}`
   :math:`\newcommand{\QCchlMax}{{Q_{\mathrm{C,max}}^{\mathrm{Chl}}}}`
   :math:`\newcommand{\VImin}{{V^{\min}_{\mathrm{I}}}}`
   :math:`\newcommand{\QCconst}{{Q_{\mathrm{C}}^{\mathrm{const}}}}`

.. _Macromolecular:

Macromolecular parameterization of growth
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To enable the macromolecular parameterization of phototrophic growth, define
:varlink:`DARWIN_MACROMOLECULAR_GROWTH` in DARWIN_OPTIONS.h.  Phytoplankton
need to have flexible nitrogen, phosphorus and iron quotas, so also define
:varlink:`DARWIN_ALLOW_NQUOTA`, :varlink:`DARWIN_ALLOW_PQUOTA` and
:varlink:`DARWIN_ALLOW_FEQUOTA`.

In order to parameterize the growth rate as a function of elemental quotas, we
assume that the available carbon, nitrogen, phosphorus and iron in the organism
are allocated optimally to macromolecular pools to achieve maximum growth rate,
:math:`P_{\mathrm{C}}`, at every instant.  To determine this growth rate, the
macromolecular requirements are expressed as a function of growth rate.  The
available quota of each element then provides a constraint on the achievable
growth rate which can be obtained by solving for :math:`P_{\mathrm{C}}` as a
function of the required quota.  The realized growth rate is the smallest of
these solutions, the one obtained from the most limiting quota.

The assumed macromolecular pools and fluxes between them are shown in
:numref:`fig_phys_pkgs_darwin_macromol_fluxes`.

.. figure:: figs/fluxes.*
   :align: center
   :alt: Elemental fluxes of macromolecular growth model
   :name: fig_phys_pkgs_darwin_macromol_fluxes

   Macromolecular pools and fluxes

They imply the following elemental quota requirements:

.. math::
   :label: eq_ess

   \QCess &= \QCchl + \QCpro + \QCRNA + \QCDNA + \QCthy + \QCother

   \QNess &= \QNchl + \QNpro + \QNRNA + \QNDNA

   \QPess &= \QPthy + \QPRNA + \QPDNA + \QPother

   \QFeess &= \Qfephoto

Any quotas beyonds these essential values will be distributed between a store
and an excess that is used to regulate uptake.

To find the required Chlorophyll quota, consider that photosynthesis is needed
for maintainance and growth

.. math::

   \op{PS} = P_{\mathrm{Chl}} Q_{\mathrm{C}}^{\op{Chl}}
           = m + (1 + E) Q_{\mathrm{C}} P_{\mathrm{C}}
   \;.

The Chlorophyll-specific photosynthesis rate is a function of the
photosynthetically active radiation, :math:`I`,

.. math::

   P_{\mathrm{Chl}}(I) = S_{\op{f}} V^{\max}_{\op{I}} f_{\op{I}}(I)
   \quad\text{with}\quad
   f_{\op{I}}(I) = 1 - e^{-A_{\op{I}}I}
   \;,

so the Chlorophyll quota required for growth rate :math:`P_{\mathrm{C}}` at
given light is

.. math::
   :label: eq_CChl

   Q_{\mathrm{C}}^{\mathrm{Chl}} = \frac{m + (1+E) Q_{\mathrm{C}} P_{\mathrm{C}}}
                                        {P_{\mathrm{Chl}}(I)}
   \;.

The photosynthetic protein pool is assumed to be proportional to Chlorophyll,

.. math::

   \QCphoto = \Apho \QCchl
   \;.

The biosynthetic protein pool to growth rate, with a temperature dependence
(only :ref:`darwin-temp-version-2` is supported)

.. math::

   \QCbio = \Abio \PC / \macromolTempFunc
   \;.

Total proteins also include a base pool of 'other' protein,

.. math::

   \QNpro = \QNproother + \QNphoto + \QNbio
   \;.

Here, the elemental quotas of the pools are related as

.. math::

   \QNphoto &= \QCphoto/\YCNprotein

   \QNbio   &= \QCbio/\YCNprotein
   \;.

..
    math::

   \QNphoto &= \QNphoto^{(0)} + \QNphoto^{(1)}\PC

   \QNbio   &= \QNbio^{(1)}\PC
   \;.

RNA pools depend on protein pools and growth rate, again with a temperature dependence,

.. math::

   \QPRNA = \APRNA \QCpro \PC / \macromolTempFunc + \QPRNAmin

..
          = \QPRNA^{(2)}\PC^2 + \QPRNA^{(1)}\PC + \QPRNAmin

with

.. math::

   \QCpro = \YCNprotein \QNpro
   \;.

..
   = \QCpro^{(0)} + \QCpro^{(1)}\PC

Using yet more stoichiometric relations,

.. math::

   \QNchl      &= \YNCchl \QCchl

   \QPthy      &= \YTHYP \QCchl

   \QNRNA      &= \QPRNA/\YPNnucacid

   \QCRNA      &= \YCNRNA\QNRNA

   \QCthy      &= \YCPPlip\QPthy

   \Qfephoto   &= \YFeNphoto\QNphoto

   \QNproother &= \QCproother/\YCNprotein

   \QNRNAmin   &= \QPRNAmin/\YPNnucacid

   \QCRNAmin   &= \YCNRNA \QNRNAmin

   \QNDNA      &= \QCDNA/\YCNDNA

   \QPDNA      &= \YPNnucacid \QNDNA
   \;,

..
    math::

   \QNchl      &= \QNchl^{(0)} + \QNchl^{(1)}\PC

   \QPthy      &= \QPthy^{(0)} + \QPthy^{(1)}\PC

   \QNRNA      &= \QNRNA^{(2)}\PC^2 + \QNRNA^{(1)}\PC + \QNRNAmin

..
   \Athy       &= \YCPPlip \YTHYP
   \ANRNA     &= \YCNprotein \AP_RNA / \YPNnucacid

and keeping track of powers of :math:`\PC`, we obtain expressions for the
essential elemental quotas as a quadratic function of growth rate (for fixed
light level),

..
   math::

   Q_{\mathrm{N}}^{\mathrm{ess}} &= \QNchl^{(0)} + \QNchl^{(1)}\PC \\
         &\quad+ \QNproother \\
         &\quad+ \QNphoto^{(0)} + \QNphoto^{(1)}\PC \\
         &\quad+ \QNbio^{(1)}\PC \\
         &\quad+ \QNRNAmin + \QNRNA^{(1)}\PC + \QNRNA^{(2)}\PC^2 \\
         &\quad+ \QNDNA \\
         &= \QN^{(0)} + \QN^{(1)}\PC + \QN^{(2)}\PC^2

..
   math::

   Q_{\mathrm{P}}^{\mathrm{ess}} &= \QPthy^{(0)} + \QPthy^{(1)}\PC \\
         &\quad+ \QPRNA^{(2)}\PC^2 + \QPRNA^{(1)}\PC + \QPRNAmin \\
         &\quad+ \QPDNA \\
         &\quad+ \QPother \\
         &= \QP^{(0)} + \QP^{(1)}\PC + \QP^{(2)}\PC^2

..
   math::

   Q_{\mathrm{Fe}}^{\mathrm{ess}} &= \Qfephoto \\
         &= \QFe^{(0)} + \QFe^{(1)}\PC

..
   math::

   Q_{\mathrm{C}}^{\mathrm{ess}} &= \QCchl^{(0)} + \QCchl^{(1)}\PC \\
         &\quad+ \QCpro^{(0)} + \QCpro^{(1)}\PC \\
         &\quad+ \QCRNAmin + \QCRNA^{(1)}\PC + \QCRNA^{(2)}\PC^2 \\
         &\quad+ \QCDNA \\
         &\quad+ \QCthy^{(0)} + \QCthy^{(1)}\PC \\
         &\quad+ \QCother

.. math::

   Q_{X}^{\mathrm{ess}} = Q_{X}^{(0)}
                        + Q_{X}^{(1)} P_{\mathrm{C}}
                        + Q_{X}^{(2)} P_{\mathrm{C}}^2
   \;.

By equating these to the actually available quotas, we obtain maximum growth
rates for each quota limitation, :math:`P_{\mathrm{C}}^X`.  The realized growth
rate is the smallest,

.. math::

   P_{\mathrm{C}} = \min\left(
       P_{\mathrm{C}}^{\mathrm{N}},
       P_{\mathrm{C}}^{\mathrm{P}},
       P_{\mathrm{C}}^{\mathrm{Fe}},
       P_{\mathrm{C}}^{\mathrm{C}}
       \right)
   \;.


No-growth, non-zero Chlorophyll case
''''''''''''''''''''''''''''''''''''

When one of the nutrient-limited growth-rate equations does not have a positive
solution, the growth rate is zero.  In this case, it is assumed that
the macromolecular requirements for Chlorophyll in the first part of this
section are still valid (but for :math:`\PC=0`).  We can then compute the maximum
amount of Chlorophyll possible for each limiting nutrient,

.. math::

  Q_\mathrm{C}^{\op{Chl,N}} &= \frac{ \QN - \QnNoChl }
                                    { \YNCchl + \Apho/\YCNprotein }

  Q_\mathrm{C}^{\op{Chl,P}} &= \frac{ \QP - \QpNoChl }{ \YTHYP }

  Q_\mathrm{C}^{\op{Chl,Fe}} &= \frac{ Q_\mathrm{Fe} } { \Apho\YFeNphoto/\YCNprotein }

where

.. math::

   \QnNoChl  &= \QNRNAmin + \QNDNA + \QNproother

   \QpNoChl  &= \QPRNAmin + \QPDNA + \QPother

are the essential quotas for zero growth.  (Without growth, no iron is required).

The carbon requirements also imply a maximum Chlorophyll value for the zero
growth case,

.. math::

   \QCchlMax = \frac{\maintConsum}{\VImin}

where

.. math::

   \VImin   &= \maintConsum \frac{ 1 + \Athy + \Apho }{ 1-\QCconst }

   \QCconst &= \QCproother + \QCRNAmin + \QCDNA + \QCother
   \;.

The realized amount of Chlorophyll is the one compatible with all these, and the
constraint from carbon requirement,

.. math::

   Q_{\mathrm{C}}^{\op{Chl}} = \min\bigl(
      Q_\mathrm{C}^{\op{Chl,N}},
      Q_\mathrm{C}^{\op{Chl,P}},
      Q_\mathrm{C}^{\op{Chl,Fe}},
      Q_{\mathrm{C}}^{\op{Chl}\max}
      \bigr)
   \;.


No-Chlorophyll case
'''''''''''''''''''

When even the minimum quota requirements for Chlorophyll are not met, the
available quotas are divided evenly between the pools needed for Chlorophyll,

.. math::

   \QNRNA     &= f \cdot \QNRNAmin

   \QNDNAactl &= f \cdot \QNDNA

   \QPRNA     &= f \cdot \QPRNAmin

   \QPDNAactl &= f \cdot \QPDNA

where

.. math::

   f = \min\left( \frac{\QN}{\QnNoChl}, \frac{\QP}{\QpNoChl} \right)
   \;.

Any excess (of the non-limiting element) goes to the nitrogen protein or
phosphorus ‘other’ pool,

.. math::

   \QNpro &= \min\left( \QN - \QNRNA - \QNDNAactl, \QNproother \right)

   \QPotheractl &= \min\left( \QP - \QPRNA - \QPDNAactl, \QPother \right)
   \;.

The essential quotas are then recomputed with these reduced pools.


Storage and uptake regulation
'''''''''''''''''''''''''''''

Nutrient storage is computed from excess quota beyond essential.  Nitrogen
storage is limited by a fixed maximum and the required cabron quota for the
store,

.. math::

   \QNstore = \min\left( \QN - \QNess, \QNstomax,
                         \frac{\QC - \QCess}{\YCNcyano}
                  \right)
   \;.

For phosphorus and iron, the quotas are limited rather than the store,

.. math::

   \QPstore &= \min\left( \QP, \Qpmax \right) - \QPess

   \QFestore &= \min\left( \QFe, \Qfemax \right) - \QFeess
   \;.

Excess nitrogen quota that cannot be stored leads to a reduction in uptake via
an additional multiplicative regulation term in :math:`U^{\mathrm{NO3}}`,

.. math::

   \op{reg}^{\mathrm{mm}}_{\mathrm{N}} =
       \frac{1.1 (\QNess + \QNstore) - \QN}{0.1 (\QNess + \QNstore)}
   \;,

and similar for phosphorus and iron.

.. tabularcolumns:: |\Y{.12}|\Y{.16}|\Y{.18}|\Y{.14}|\Y{.1}|\Y{.3}|

.. csv-table:: Traits of the macromolecular growth model
   :delim: &
   :widths: 13,20,22,16,11,18
   :class: longtable
   :header: symbol, trait, param, default, units, description
   :name: tab_phys_pkg_darwin_macromol_traits

   :math:`\ECoiiProd`   & :varlink:`ECo2Prod`     & :varlink:`a_ECo2Prod`     & 0.774       & unitless                   & CO2 production ratio
   :math:`\maintConsum` & :varlink:`maintConsum`  & :varlink:`a_maintConsum`  & 0.393/day   & 1/s                        & maintenance carbohydrate consumption
   :math:`\VImax`       & :varlink:`VI_max`       & :varlink:`a_VI_max`       & 277/day     & molC/s / (molC in Chl)     & carbon fixing rate
                        &                         & :varlink:`b_VI_max`       & 0           &                            &
   :math:`\AI`          & :varlink:`A_I`          & :varlink:`a_A_I`          & 0.008633641 & m\ :sup:`2`\ s/μmol        & coefficient characterizing the absorption cross section
   :math:`\Sf`          & :varlink:`Sf`           &                          & 1.0         & unitless                   & enhancement of photosynthesis due to size
   :math:`\Apho`        & :varlink:`A_pho`        & :varlink:`a_A_pho`        & 16.0        & molC / (molC in Chl)       & A constant of proportionality
   :math:`\Abio`        & :varlink:`A_bio`        & :varlink:`a_A_bio`        & 0.2711*day  & molC / (molC/s)            & constant for variable part of biosynthesis protein
   :math:`\APRNA`       & :varlink:`AP_RNA`       & :varlink:`a_AP_RNA`       & 0.00423*day & molP / (molC/s)            & constant for Variable part of RNA
   :math:`\QCother`     & :varlink:`QC_other`     & :varlink:`a_QC_other`     & 0.0182      & molC / molC                & constant pool of structural lipids and carbs
   :math:`\QCproother`  & :varlink:`QC_pro_other` & :varlink:`a_QC_pro_other` & 0.24        & molC / molC                & constant pool of essential proteins
   :math:`\QPother`     & :varlink:`QP_other`     & :varlink:`a_QP_other`     & 6.5344E-4   & molP / molC                & constant part of phosphorus
   :math:`\QPRNAmin`    & :varlink:`QP_RNA_min`   & :varlink:`a_QP_RNA_min`   & 2.23E-4     & molP / molC                & minimum RNA in the cell
   :math:`\QCDNA`       & :varlink:`QC_DNA`       & :varlink:`a_QC_DNA`       & 9.41E-4     & molC / molC                & constant part of DNA in carbon
   :math:`\QNstomax`    & :varlink:`QN_sto_max`   & :varlink:`a_QN_sto_max`   & 0.035       & molN / molC                & maximum nitrogen storage
                        &                         & :varlink:`b_QN_sto_max`   & 0           &                            &
   :math:`\Qpmax`       & :varlink:`Qp_max`       & :varlink:`a_Qp_max`       & 0.0052      & molP / molC                & maximum phosphorus quota
                        &                         & :varlink:`b_Qp_max`       & 0           &                            &
   :math:`\Qfemax`      & :varlink:`Qfe_max`      & :varlink:`a_Qfe_max`      & 2.436E-4    & molFe / molC               & maximum iron quota
                        &                         & :varlink:`b_Qfe_max`      & 0           &                            &
   :math:`\YCPPlip`     & :varlink:`Y_CP_Plip`    & :varlink:`a_Y_CP_Plip`    & 40.0        & molC / molP                & C/P molar ratio of thylacoid membrane
   :math:`\YCNprotein`  & :varlink:`Y_CN_protein` & :varlink:`a_Y_CN_protein` & 5.3/1.4     & molC / molN                & C/N molar ratio in protein
   :math:`\YNCchl`      & :varlink:`Y_NC_chl`     & :varlink:`a_Y_NC_chl`     & 4.0/55.0    & molN / molC                & N/C molar ratio in chlorophyll
   :math:`\YCNcyano`    & :varlink:`Y_CN_cyano`   & :varlink:`a_Y_CN_cyano`   & 2.0         & molC / molN                & C/N molar ratio of cyanophycin
   :math:`\YPNnucacid`  & :varlink:`Y_PN_nucacid` & :varlink:`a_Y_PN_nucacid` & 1/3.75      & molP / molN                & P/N molar ratio of RNA
   :math:`\YCNDNA`      & :varlink:`Y_CN_DNA`     & :varlink:`a_Y_CN_DNA`     & 9.75/3.75   & molC / molN                & C/N molar ratio of DNA
   :math:`\YCNRNA`      & :varlink:`Y_CN_RNA`     & :varlink:`a_Y_CN_RNA`     & 9.50/3.75   & molC / molN                & C/N molar ratio of RNA
   :math:`\YTHYP`       & :varlink:`Y_THY_P`      & :varlink:`a_Y_THY_P`      & 0.028163    & molP / (molC in Chl)       & the stoichiometric ratio for cell phosphorus in thylakoid membrane to chlorophyll
   :math:`\YFeNphoto`   & :varlink:`Y_FeN_photo`  & :varlink:`a_Y_FeN_photo`  & 0.00163     & molFe / molN               & Fe/N ratio in photosystem iron


.. csv-table:: Dependent traits of the macromolecular growth model
   :delim: &
   :widths: 15,18,25,42
   :header: symbol, trait, units, description
   :name: tab_phys_pkg_darwin_macromol_deptraits

   :math:`\QNproother` & :varlink:`QN_pro_other` & molN / molC              & nitrogen in essential proteins
   :math:`\QNRNAmin`   & :varlink:`QN_RNA_min`   & molN / molC              & constant part of RNA in nitrogen
   :math:`\QCRNAmin`   & :varlink:`QC_RNA_min`   & molN / molC              & constant part of RNA in carbon
   :math:`\QNDNA`      & :varlink:`QN_DNA`       & molN / molC              & DNA in nitrogen
   :math:`\QPDNA`      & :varlink:`QP_DNA`       & molP / molC              & DNA in phosphorous
   :math:`\Athy`       & :varlink:`A_thy`        & molC / (molC in chl)     & ratio of carbon in thylakoid membrane to chlorophyll
   :math:`\ANRNA`      & :varlink:`AN_RNA`       & s molN / molN            & constant for Variable part of RNA
   :math:`\VImin`      & :varlink:`VI_min`       & molC/s / (molC in Chl)   & minimum photosynthesis rate
   :math:`\QCchlMax`   & :varlink:`QC_chlMax`    & molC / molC              & maximum chlorophyll concentration at minimum light
   :math:`\QnNoChl`    & :varlink:`QnNoChl`      & molN / molC              & minimum QN at zero growth rate
   :math:`\QpNoChl`    & :varlink:`QpNoChl`      & molP / molC              & minimum QP at zero growth rate
   :math:`\QfeNoChl`   & :varlink:`QfeNoChl`     & molFe / molC             & minimum QFe at zero growth rate
   :math:`\QCconst`    & :varlink:`QC_const`     & molC / molC              & constant portion of the cell

.. csv-table:: Parameters of the macromolecular growth model
   :delim: &
   :widths: 25,11,9,55
   :header: param, default, units, description
   :name: tab_phys_pkg_darwin_macromol_params

   :varlink:`TempAeArrMacromol` & --8420 & K & slope for pseudo-Arrhenius for macromolecular (TEMP_VERSION 2)

